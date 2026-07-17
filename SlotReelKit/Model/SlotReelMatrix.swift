//
//  SlotReelMatrix.swift
//  SlotReelKit
//
//  Result matrix model for a stopped reel grid.
//

import Foundation

/// A `visibleRowCount × columnCount` result matrix used to stop reels at exact symbols.
///
/// Row `0` represents the top visible row in each column.
public struct SlotReelMatrix: Equatable, Sendable {
    /// Matrix values indexed as `values[row][column]`.
    public let values: [[Int]]

    /// Number of rows in the matrix.
    public var rowCount: Int { values.count }

    /// Number of columns in the matrix.
    public var columnCount: Int { values.first?.count ?? 0 }

    /// Creates a result matrix.
    public init(values: [[Int]]) {
        self.values = values
    }

    /// Reads a symbol index at the given row and column.
    public func symbol(atRow row: Int, column: Int) -> Int? {
        guard row >= 0, row < rowCount else { return nil }
        guard column >= 0, column < columnCount else { return nil }
        return values[row][column]
    }
}
