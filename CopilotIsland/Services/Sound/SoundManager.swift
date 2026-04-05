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
        guard UserDefaults.standard.bool(forKey: "soundEnabled") else { return }
        player?.currentTime = 0
        player?.play()
    }
}
