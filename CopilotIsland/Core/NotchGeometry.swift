//
//  NotchGeometry.swift
//  CopilotIsland
//
//  Geometric calculations for the notch overlay window.
//  Adapted from ClaudeIsland (Apache 2.0).
//

import AppKit

struct NotchGeometry {
    let deviceNotchRect: CGRect
    let screenRect: CGRect
    let windowHeight: CGFloat

    var notchScreenRect: CGRect {
        CGRect(
            x: screenRect.midX - deviceNotchRect.width / 2,
            y: screenRect.maxY - deviceNotchRect.height,
            width: deviceNotchRect.width,
            height: deviceNotchRect.height
        )
    }

    func isPointInNotch(_ point: CGPoint) -> Bool {
        let expanded = notchScreenRect.insetBy(dx: -16, dy: -8)
        return expanded.contains(point)
    }

    func isPointInOpenedPanel(_ point: CGPoint, size: CGSize) -> Bool {
        let panelRect = openedPanelRect(size: size)
        return panelRect.contains(point)
    }

    func isPointOutsidePanel(_ point: CGPoint, size: CGSize) -> Bool {
        !isPointInOpenedPanel(point, size: size) && !isPointInNotch(point)
    }

    func openedPanelRect(size: CGSize) -> CGRect {
        CGRect(
            x: screenRect.midX - size.width / 2,
            y: screenRect.maxY - size.height - 4,
            width: size.width,
            height: size.height
        )
    }
}

// MARK: - NSScreen Extensions

extension NSScreen {
    var hasNotch: Bool {
        guard #available(macOS 12.0, *) else { return false }
        return safeAreaInsets.top > 0
    }

    var notchRect: CGRect? {
        guard hasNotch else { return nil }
        // MacBook Pro notch: ~126x37 at 14", ~196x37 at 16" (points)
        let notchWidth: CGFloat = frame.width > 2000 ? 196 : 126
        let notchHeight: CGFloat = 37
        return CGRect(x: 0, y: 0, width: notchWidth, height: notchHeight)
    }
}
