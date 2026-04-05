//
//  AppDelegate.swift
//  CopilotIsland
//

import AppKit
import Combine

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowManager: WindowManager?
    private var sessionMonitor: CopilotSessionMonitor?
    let sparkleUpdater = SparkleUpdater()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        sessionMonitor = CopilotSessionMonitor()
        windowManager = WindowManager(sessionMonitor: sessionMonitor!, sparkleUpdater: sparkleUpdater)
        windowManager?.createNotchWindow()

        sessionMonitor?.startMonitoring()
    }

    func applicationWillTerminate(_ notification: Notification) {
        sessionMonitor?.stopMonitoring()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
