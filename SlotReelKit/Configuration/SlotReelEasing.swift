//
//  SlotReelEasing.swift
//  SlotReelKit
//
//  Easing functions used by reel scroll animations.
//

import Foundation

/// Supported easing curves for reel scrolling.
public enum SlotReelEasing: Equatable, Sendable {
    /// Standard cubic ease-in-out curve.
    case easeInOutCubic

    /// Linear interpolation without acceleration.
    case linear

    /// Maps a linear progress value `[0, 1]` to an eased progress value `[0, 1]`.
    public func value(at linearProgress: Double) -> Double {
        let progress = min(1, max(0, linearProgress))
        switch self {
        case .linear:
            return progress
        case .easeInOutCubic:
            return Self.cubicEaseInOut(progress)
        }
    }

    private static func cubicEaseInOut(_ value: Double) -> Double {
        if value < 0.5 {
            return 4 * value * value * value
        }
        let shifted = 2 * value - 2
        return 0.5 * shifted * shifted * shifted + 1
    }
}
