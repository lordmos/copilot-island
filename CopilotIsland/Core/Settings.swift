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

    private init() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        launchAtLogin = UserDefaults.standard.bool(forKey: "launchAtLogin")
    }
}
