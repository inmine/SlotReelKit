//
//  SlotReelConfiguration.swift
//  SlotReelKit
//
//  Layout and geometry configuration for a slot reel grid.
//

import CoreGraphics
import Foundation

/// Defines the physical layout of the reel grid.
///
/// Use ``SlotReelConfiguration/default(columnCount:visibleRowCount:symbolCount:)`` for a quick start,
/// or build a fully custom layout with explicit sizes.
public struct SlotReelConfiguration: Equatable, Sendable {
    /// Number of vertical reel columns. Default is `3`.
    public var columnCount: Int

    /// Number of visible symbol rows in the viewport. Default is `3`.
    public var visibleRowCount: Int

    /// Total distinct symbols in one repeating cycle. Default is `5`.
    public var symbolCount: Int

    /// Extra rows rendered above and below the viewport to avoid blank frames while scrolling.
    public var renderBufferRows: Int

    /// Outer container size including border area.
    public var outerSize: CGSize

    /// Padding between the outer border and the reel grid.
    public var gridPadding: CGFloat

    /// Spacing between adjacent cells horizontally and vertically.
    public var cellSpacing: CGFloat

    /// Creates a layout configuration.
    public init(
        columnCount: Int = 3,
        visibleRowCount: Int = 3,
        symbolCount: Int = 5,
        renderBufferRows: Int = 2,
        outerSize: CGSize = CGSize(width: 298, height: 199),
        gridPadding: CGFloat = 10,
        cellSpacing: CGFloat = 10
    ) {
        self.columnCount = max(1, columnCount)
        self.visibleRowCount = max(1, visibleRowCount)
        self.symbolCount = max(1, symbolCount)
        self.renderBufferRows = max(0, renderBufferRows)
        self.outerSize = outerSize
        self.gridPadding = gridPadding
        self.cellSpacing = cellSpacing
    }

    /// Returns a standard 3×3 slot layout.
    public static func `default`(
        columnCount: Int = 3,
        visibleRowCount: Int = 3,
        symbolCount: Int = 5,
        outerSize: CGSize = CGSize(width: 298, height: 199)
    ) -> SlotReelConfiguration {
        SlotReelConfiguration(
            columnCount: columnCount,
            visibleRowCount: visibleRowCount,
            symbolCount: symbolCount,
            outerSize: outerSize
        )
    }

    /// Width of the inner grid content area.
    public var gridContentWidth: CGFloat {
        outerSize.width - gridPadding * 2
    }

    /// Height of the inner grid content area.
    public var gridContentHeight: CGFloat {
        outerSize.height - gridPadding * 2
    }

    /// Width of a single symbol cell.
    public var cellWidth: CGFloat {
        (gridContentWidth - cellSpacing * CGFloat(max(0, columnCount - 1))) / CGFloat(columnCount)
    }

    /// Height of a single symbol cell.
    public var cellHeight: CGFloat {
        (gridContentHeight - cellSpacing * CGFloat(max(0, visibleRowCount - 1))) / CGFloat(visibleRowCount)
    }

    /// Distance advanced by one symbol step, including spacing.
    public var itemStride: CGFloat {
        cellHeight + cellSpacing
    }

    /// Total slot views rendered per column (visible rows + top/bottom buffers).
    public var renderedRowCount: Int {
        visibleRowCount + renderBufferRows * 2
    }

    /// Height of one full symbol cycle.
    public var cycleHeight: CGFloat {
        CGFloat(symbolCount) * itemStride
    }
}
