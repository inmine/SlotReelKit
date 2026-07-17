//
//  SlotReelSpinPlan.swift
//  SlotReelKit
//
//  Per-column animation plan produced by SlotReelEngine.
//

import CoreGraphics
import Foundation

/// Describes one column's scroll animation within a spin session.
public struct SlotReelSpinPlan: Equatable, Sendable {
    /// Zero-based column index.
    public let column: Int

    /// Offset at animation start.
    public let fromOffset: CGFloat

    /// Offset at animation end before snapping.
    public let toOffset: CGFloat

    /// Final snapped offset applied after animation completes.
    public let snapOffset: CGFloat

    /// Animation duration in seconds.
    public let duration: TimeInterval

    /// Delay before this column starts animating.
    public let startDelay: TimeInterval

    /// Symbol overrides keyed by absolute item index for the stopped viewport.
    public let symbolOverrides: [Int: Int]

    /// Creates a column spin plan.
    public init(
        column: Int,
        fromOffset: CGFloat,
        toOffset: CGFloat,
        snapOffset: CGFloat,
        duration: TimeInterval,
        startDelay: TimeInterval,
        symbolOverrides: [Int: Int]
    ) {
        self.column = column
        self.fromOffset = fromOffset
        self.toOffset = toOffset
        self.snapOffset = snapOffset
        self.duration = duration
        self.startDelay = startDelay
        self.symbolOverrides = symbolOverrides
    }
}
