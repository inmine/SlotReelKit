//
//  SlotReelColumnRepresentable.swift
//  SlotReelKit
//
//  SwiftUI bridge for SlotReelColumnView.
//

import SwiftUI

/// Embeds a UIKit reel column inside SwiftUI and binds it to ``SlotReelEngine``.
public struct SlotReelColumnRepresentable: UIViewRepresentable {
    @ObservedObject private var engine: SlotReelEngine
    private let column: Int
    private let appearance: SlotReelAppearanceConfiguration

    /// Creates a column representable for the given engine and column index.
    public init(
        engine: SlotReelEngine,
        column: Int,
        appearance: SlotReelAppearanceConfiguration
    ) {
        self.engine = engine
        self.column = column
        self.appearance = appearance
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(column: column, engine: engine)
    }

    public func makeUIView(context: Context) -> SlotReelColumnView {
        let columnView = SlotReelColumnView(
            configuration: engine.configuration,
            appearance: appearance,
            animationConfiguration: engine.animationConfiguration
        )
        columnView.setContentOffset(engine.columnOffsets[column], animated: false)
        columnView.updateSymbolOverrides(engine.symbolOverrides[column])
        context.coordinator.didApplyInitialOffset = true
        return columnView
    }

    public func updateUIView(_ uiView: SlotReelColumnView, context: Context) {
        uiView.updateAppearance(appearance)

        if !context.coordinator.didApplyInitialOffset {
            uiView.setContentOffset(engine.columnOffsets[column], animated: false)
            context.coordinator.didApplyInitialOffset = true
        }

        uiView.updateSymbolOverrides(engine.symbolOverrides[column])

        guard let session = engine.spinSession else { return }
        guard context.coordinator.processedSessionID != session.id else { return }
        guard let plan = session.plan(for: column) else { return }

        context.coordinator.processedSessionID = session.id

        uiView.runSpinAnimation(plan: plan) { [weak engine] in
            Task { @MainActor in
                engine?.markColumnScrollFinished(column: column, sessionID: session.id)
            }
        }
    }

    /// Stores column-specific bridge state.
    public final class Coordinator {
        let column: Int
        weak var engine: SlotReelEngine?
        var didApplyInitialOffset = false
        var processedSessionID: UUID?

        init(column: Int, engine: SlotReelEngine) {
            self.column = column
            self.engine = engine
        }
    }
}
