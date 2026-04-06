//
//  SoundManager.swift
//  CopilotIsland
//
//  8-bit sound effects for session lifecycle events.
//  - agent_done.wav:   ascending chime (task complete)
//  - agent_failed.wav: descending square-wave (abort / error / shutdown)
//  Respects the user's soundEnabled preference.
//

import AVFoundation
import Foundation

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    private var donePlayer: AVAudioPlayer?
    private var failedPlayer: AVAudioPlayer?

    private init() {
        if let url = Bundle.main.url(forResource: "agent_done", withExtension: "wav") {
            donePlayer = try? AVAudioPlayer(contentsOf: url)
            donePlayer?.prepareToPlay()
        }
        if let url = Bundle.main.url(forResource: "agent_failed", withExtension: "wav") {
            failedPlayer = try? AVAudioPlayer(contentsOf: url)
            failedPlayer?.prepareToPlay()
        }
    }

    func playAgentDone() {
        guard isSoundEnabled else { return }
        donePlayer?.currentTime = 0
        donePlayer?.play()
    }

    func playAgentFailed() {
        guard isSoundEnabled else { return }
        failedPlayer?.currentTime = 0
        failedPlayer?.play()
    }

    private var isSoundEnabled: Bool {
        if UserDefaults.standard.object(forKey: "soundEnabled") != nil {
            return UserDefaults.standard.bool(forKey: "soundEnabled")
        }
        return true  // default: on
    }
}
