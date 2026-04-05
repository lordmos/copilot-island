//
//  Settings.swift
//  CopilotIsland
//

import Foundation
import Combine

class Settings: ObservableObject {
    static let shared = Settings()

    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }

    @Published var launchAtLogin: Bool {
        didSet { UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin") }
    }

    @Published var selectedModel: String {
        didSet { UserDefaults.standard.set(selectedModel, forKey: "selectedModel") }
    }

    private init() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
        selectedModel = UserDefaults.standard.string(forKey: "selectedModel") ?? "gpt-4o"
    }

    let availableModels = [
        "gpt-4o",
        "gpt-4o-mini",
        "claude-3-5-sonnet",
        "phi-3-medium-128k-instruct",
        "meta-llama-3-70b-instruct"
    ]
}
