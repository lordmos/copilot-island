//
//  CopilotSessionWatcher.swift
//  CopilotIsland
//
//  Watches ~/.copilot/session-state/ for new sessions and streams
//  events from each session's events.jsonl file.
//  No hook scripts needed — pure file system observation.
//

import Foundation
import os.log

private let logger = Logger(subsystem: "com.lordmos.CopilotIsland", category: "SessionWatcher")

actor CopilotSessionWatcher {
    static let shared = CopilotSessionWatcher()

    private let stateDir: URL
    private var dirWatcher: DispatchSourceFileSystemObject?
    private var sessionWatchers: [String: SessionFileWatcher] = [:]
    private var dirFD: Int32 = -1

    private init() {
        stateDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".copilot/session-state")
    }

    func start() {
        try? FileManager.default.createDirectory(at: stateDir, withIntermediateDirectories: true)
        scanExistingSessions()
        watchDirectory()
    }

    func stop() {
        dirWatcher?.cancel()
        dirWatcher = nil
        if dirFD >= 0 { close(dirFD); dirFD = -1 }
        for (_, watcher) in sessionWatchers { watcher.stop() }
        sessionWatchers.removeAll()
    }

    // MARK: - Directory Watching

    private func watchDirectory() {
        dirFD = open(stateDir.path, O_EVTONLY)
        guard dirFD >= 0 else {
            logger.error("Failed to open session-state dir: \(self.stateDir.path)")
            return
        }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: dirFD,
            eventMask: [.write, .attrib],
            queue: .global(qos: .utility)
        )

        source.setEventHandler { [weak self] in
            Task { await self?.scanExistingSessions() }
        }

        source.setCancelHandler { [weak self] in
            Task {
                guard let self else { return }
                let fd = await self.dirFD
                if fd >= 0 { close(fd) }
            }
        }

        dirWatcher = source
        source.resume()
    }

    private func scanExistingSessions() {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: stateDir,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: .skipsHiddenFiles
        ) else { return }

        for url in contents {
            let sessionId = url.lastPathComponent
            guard sessionId.count == 36 else { continue } // UUID format
            if sessionWatchers[sessionId] == nil {
                startWatchingSession(sessionId: sessionId, dir: url)
            }
        }
    }

    private func startWatchingSession(sessionId: String, dir: URL) {
        let workspace = loadWorkspace(dir: dir)
        let cwd = workspace?.cwd ?? dir.path

        Task {
            await SessionStore.shared.process(.sessionDiscovered(
                sessionId: sessionId,
                cwd: cwd,
                workspace: workspace
            ))
        }

        let watcher = SessionFileWatcher(sessionId: sessionId, dir: dir)
        sessionWatchers[sessionId] = watcher
        watcher.start()
    }

    private func loadWorkspace(dir: URL) -> CopilotWorkspace? {
        let yamlURL = dir.appendingPathComponent("workspace.yaml")
        guard let data = try? Data(contentsOf: yamlURL),
              let yaml = String(data: data, encoding: .utf8) else { return nil }
        return parseWorkspaceYAML(yaml)
    }

    /// Minimal YAML parser for the workspace.yaml structure.
    private func parseWorkspaceYAML(_ yaml: String) -> CopilotWorkspace? {
        var dict: [String: String] = [:]
        for line in yaml.components(separatedBy: "\n") {
            let parts = line.components(separatedBy: ": ")
            guard parts.count >= 2 else { continue }
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1...].joined(separator: ": ").trimmingCharacters(in: .whitespaces)
            dict[key] = value
        }
        guard let id = dict["id"] else { return nil }
        return CopilotWorkspace(
            id: id,
            cwd: dict["cwd"],
            gitRoot: dict["git_root"],
            branch: dict["branch"],
            summary: dict["summary"],
            createdAt: dict["created_at"],
            updatedAt: dict["updated_at"]
        )
    }
}

// MARK: - Per-Session File Watcher

final class SessionFileWatcher: @unchecked Sendable {
    let sessionId: String
    let dir: URL
    private var source: DispatchSourceFileSystemObject?
    private var fd: Int32 = -1
    private var offset: UInt64 = 0

    init(sessionId: String, dir: URL) {
        self.sessionId = sessionId
        self.dir = dir
    }

    func start() {
        let eventsURL = dir.appendingPathComponent("events.jsonl")

        // Read existing events first
        if let data = try? Data(contentsOf: eventsURL) {
            offset = UInt64(data.count)
            parseEvents(data: data, sessionId: sessionId)
        }

        fd = open(eventsURL.path, O_EVTONLY)
        guard fd >= 0 else { return }

        let src = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .extend],
            queue: .global(qos: .utility)
        )

        let capturedId = sessionId
        let capturedURL = eventsURL

        src.setEventHandler { [weak self] in
            guard let self else { return }
            self.readNewEvents(url: capturedURL, sessionId: capturedId)
        }

        src.setCancelHandler { [weak self] in
            guard let self else { return }
            if self.fd >= 0 { close(self.fd); self.fd = -1 }
        }

        source = src
        src.resume()
    }

    func stop() {
        source?.cancel()
        source = nil
    }

    private func readNewEvents(url: URL, sessionId: String) {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return }
        defer { try? fileHandle.close() }

        try? fileHandle.seek(toOffset: offset)
        let newData = fileHandle.readDataToEndOfFile()
        guard !newData.isEmpty else { return }

        offset += UInt64(newData.count)
        parseEvents(data: newData, sessionId: sessionId)
    }

    private func parseEvents(data: Data, sessionId: String) {
        guard let text = String(data: data, encoding: .utf8) else { return }
        let lines = text.components(separatedBy: "\n").filter { !$0.isEmpty }
        let decoder = JSONDecoder()

        for line in lines {
            guard let lineData = line.data(using: .utf8),
                  let event = try? decoder.decode(CopilotRawEvent.self, from: lineData)
            else { continue }
            handleEvent(event, sessionId: sessionId)
        }
    }

    private func handleEvent(_ raw: CopilotRawEvent, sessionId: String) {
        let data = raw.data
        Task {
            switch raw.type {
            case "user.message":
                let content = data?.content ?? ""
                await SessionStore.shared.process(.userMessageSent(sessionId: sessionId, content: content))

            case "assistant.turn_start":
                await SessionStore.shared.process(.assistantTurnStarted(sessionId: sessionId))

            case "assistant.message":
                let content = data?.content ?? ""
                let messageId = data?.messageId ?? UUID().uuidString
                await SessionStore.shared.process(.assistantMessageReceived(
                    sessionId: sessionId, content: content, messageId: messageId
                ))

            case "tool.execution_start":
                let toolCallId = data?.toolCallId ?? UUID().uuidString
                let toolName = data?.toolName ?? "unknown"
                let args = data?.arguments?.stringValue ?? "{}"
                await SessionStore.shared.process(.toolStarted(
                    sessionId: sessionId, toolCallId: toolCallId,
                    toolName: toolName, arguments: args
                ))

            case "tool.execution_complete":
                let toolCallId = data?.toolCallId ?? UUID().uuidString
                let success = data?.success ?? true
                let result = data?.result?.stringValue ?? ""
                await SessionStore.shared.process(.toolCompleted(
                    sessionId: sessionId, toolCallId: toolCallId,
                    success: success, result: result
                ))

            case "assistant.turn_end":
                await SessionStore.shared.process(.assistantTurnEnded(sessionId: sessionId))

            case "abort":
                await SessionStore.shared.process(.sessionAborted(sessionId: sessionId))

            case "session.error":
                let reason = data?.reason ?? "Unknown error"
                await SessionStore.shared.process(.sessionError(sessionId: sessionId, reason: reason))

            case "session.shutdown":
                await SessionStore.shared.process(.sessionShutdown(sessionId: sessionId))

            default:
                break
            }
        }
    }
}
