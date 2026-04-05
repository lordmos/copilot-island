//
//  AppDelegate.swift
//  CopilotIsland
//

import AppKit
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    private var windowManager: WindowManager?
    private var sessionMonitor: CopilotSessionMonitor?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        sessionMonitor = CopilotSessionMonitor()
        windowManager = WindowManager(sessionMonitor: sessionMonitor!)
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
