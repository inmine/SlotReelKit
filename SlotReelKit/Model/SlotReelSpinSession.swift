//
//  SlotReelSpinSession.swift
//  SlotReelKit
//
//  Active spin session containing all column animation plans.
//

import Foundation

/// Represents one full spin across all columns.
public struct SlotReelSpinSession: Equatable, Sendable {
    /// Unique identifier for the session.
    public let id: UUID

    /// Animation plans for each column.
    public let columns: [SlotReelSpinPlan]

    /// Creates a spin session.
    public init(id: UUID = UUID(), columns: [SlotReelSpinPlan]) {
        self.id = id
        self.columns = columns
    }

    /// Returns the plan for a specific column, if present.
    public func plan(for column: Int) -> SlotReelSpinPlan? {
        columns.first { $0.column == column }
    }
}
