//
//  CopilotIslandApp.swift
//  CopilotIsland
//
//  Dynamic Island for monitoring GitHub Copilot CLI sessions.
//

import SwiftUI

@main
struct CopilotIslandApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        SwiftUI.Settings {
            EmptyView()
        }
    }
}
