//
//  SoundManager.swift
//  CopilotIsland
//
//  Plays the 8-bit "agent done" chime when the assistant finishes a turn.
//  Respects the user's soundEnabled preference.
//

import AVFoundation
import Foundation

@MainActor
final class SoundManager {
    static let shared = SoundManager()

    private var player: AVAudioPlayer?

    private init() {
        guard let url = Bundle.main.url(forResource: "agent_done", withExtension: "wav") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.prepareToPlay()
    }

    func playAgentDone() {
        // @AppStorage defaults to true but only writes UserDefaults when the user changes the toggle.
        // UserDefaults.bool(forKey:) returns false if the key was never written, so we check explicitly.
        let soundEnabled: Bool
        if UserDefaults.standard.object(forKey: "soundEnabled") != nil {
            soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
        } else {
            soundEnabled = true  // default: on
        }
        guard soundEnabled else { return }
        player?.currentTime = 0
        player?.play()
    }
}
