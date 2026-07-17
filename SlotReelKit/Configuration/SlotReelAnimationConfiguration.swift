//
//  SlotReelAnimationConfiguration.swift
//  SlotReelKit
//
//  Animation timing configuration for reel spins.
//

import Foundation

/// Controls spin duration, stagger, and cycle counts for each column.
public struct SlotReelAnimationConfiguration: Equatable, Sendable {
    /// Base number of full symbol cycles before stopping on column 0.
    public var baseCycleCount: Int

    /// Additional cycles added per column index (`column * cycleIncrementPerColumn`).
    public var cycleIncrementPerColumn: Int

    /// Delay before each subsequent column starts spinning.
    public var columnStartStagger: TimeInterval

    /// Base animation duration for column 0.
    public var baseDuration: TimeInterval

    /// Duration increment added per column index.
    public var durationIncrementPerColumn: TimeInterval

    /// Easing curve applied while scrolling.
    public var easing: SlotReelEasing

    /// Creates an animation configuration.
    public init(
        baseCycleCount: Int = 15,
        cycleIncrementPerColumn: Int = 5,
        columnStartStagger: TimeInterval = 0.2,
        baseDuration: TimeInterval = 2.0,
        durationIncrementPerColumn: TimeInterval = 0.5,
        easing: SlotReelEasing = .easeInOutCubic
    ) {
        self.baseCycleCount = max(0, baseCycleCount)
        self.cycleIncrementPerColumn = max(0, cycleIncrementPerColumn)
        self.columnStartStagger = max(0, columnStartStagger)
        self.baseDuration = max(0.1, baseDuration)
        self.durationIncrementPerColumn = max(0, durationIncrementPerColumn)
        self.easing = easing
    }

    /// Default animation profile matching common slot-machine UX.
    public static let `default` = SlotReelAnimationConfiguration()

    /// Returns the cycle count for a given column index.
    public func cycleCount(forColumn column: Int) -> Int {
        baseCycleCount + max(0, column) * cycleIncrementPerColumn
    }

    /// Returns the start delay for a given column index.
    public func startDelay(forColumn column: Int) -> TimeInterval {
        TimeInterval(max(0, column)) * columnStartStagger
    }

    /// Returns the animation duration for a given column index.
    public func duration(forColumn column: Int) -> TimeInterval {
        baseDuration + TimeInterval(max(0, column)) * durationIncrementPerColumn
    }
}
