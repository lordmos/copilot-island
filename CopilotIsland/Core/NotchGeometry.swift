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

    private let peekWidth: CGFloat = 50   // must match NotchViewModel.peekWidth

    func isPointInNotch(_ point: CGPoint) -> Bool {
        // Extend to include left/right peek areas so hovering there also triggers expansion.
        let expanded = notchScreenRect.insetBy(dx: -(16 + peekWidth), dy: -8)
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
        // Panel is flush with the screen top. The height already includes the notch inset
        // (see NotchViewModel.openedSize), so the panel covers the notch area seamlessly.
        CGRect(
            x: screenRect.midX - size.width / 2,
            y: screenRect.maxY - size.height,
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

    /// Dynamic notch rect in logical points, derived from actual screen APIs.
    /// Uses auxiliaryTopLeftArea/Right to compute exact notch width on macOS 12+.
    /// Falls back to known approximate values on older OS / non-notch displays.
    var notchRect: CGRect? {
        guard hasNotch else { return nil }
        guard #available(macOS 12.0, *) else { return nil }

        let notchHeight = safeAreaInsets.top           // exact notch height in points
        let fullWidth   = frame.width
        let leftW       = auxiliaryTopLeftArea?.width  ?? 0
        let rightW      = auxiliaryTopRightArea?.width ?? 0

        let notchWidth: CGFloat
        if leftW > 0, rightW > 0 {
            // +4 overlaps the edge curvature so the pill blends with the bezel
            notchWidth = fullWidth - leftW - rightW + 4
        } else {
            // Fallback: 345 native px / 2x Retina = 172.5 pts (same on 14" and 16" MBP)
            notchWidth = 174
        }
        return CGRect(x: 0, y: 0, width: notchWidth, height: notchHeight)
    }
}

