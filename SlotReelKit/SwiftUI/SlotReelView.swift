//
//  SlotReelView.swift
//  SlotReelKit
//
//  SwiftUI entry point for displaying a full slot reel grid.
//

import SwiftUI

/// A complete slot reel grid composed of multiple vertically scrolling columns.
///
/// Example:
/// ```swift
/// SlotReelView(
///     engine: engine,
///     appearance: SlotReelAppearanceConfiguration(
///         symbolImageProviderClosure: { index in
///             UIImage(named: "symbol_\(index + 1)")
///         }
///     )
/// )
/// ```
public struct SlotReelView: View {
    @ObservedObject private var engine: SlotReelEngine
    private let appearance: SlotReelAppearanceConfiguration

    /// Creates a reel grid bound to the given engine.
    public init(
        engine: SlotReelEngine,
        appearance: SlotReelAppearanceConfiguration
    ) {
        self.engine = engine
        self.appearance = appearance
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: appearance.containerCornerRadius, style: .continuous)
                .fill(Color(appearance.containerBackgroundColor))

            HStack(spacing: engine.configuration.cellSpacing) {
                ForEach(0..<engine.configuration.columnCount, id: \.self) { column in
                    SlotReelColumnRepresentable(
                        engine: engine,
                        column: column,
                        appearance: appearance
                    )
                    .frame(
                        width: engine.configuration.cellWidth,
                        height: engine.configuration.gridContentHeight
                    )
                }
            }
            .padding(engine.configuration.gridPadding)
        }
        .frame(
            width: engine.configuration.outerSize.width,
            height: engine.configuration.outerSize.height
        )
    }
}
