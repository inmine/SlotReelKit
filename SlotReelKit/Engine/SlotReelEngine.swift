//
//  SlotReelEngine.swift
//  SlotReelKit
//
//  Core spin coordinator for slot reel grids.
//

import Combine
import Foundation

/// Coordinates reel offsets, spin sessions, and stop results.
///
/// Typical usage:
/// ```swift
/// let engine = SlotReelEngine(configuration: .default())
/// engine.startRoll(targetSymbolIndex: 2) {
///     print("Spin finished")
/// }
/// ```
@MainActor
public final class SlotReelEngine: ObservableObject {
    /// Layout configuration.
    public let configuration: SlotReelConfiguration

    /// Animation configuration.
    public let animationConfiguration: SlotReelAnimationConfiguration

    /// Current vertical offsets for each column.
    @Published public private(set) var columnOffsets: [CGFloat]

    /// Symbol overrides keyed by absolute item index for each column.
    @Published public private(set) var symbolOverrides: [[Int: Int]]

    /// Whether any column is currently rolling.
    @Published public private(set) var isRolling = false

    /// Active spin session consumed by column views.
    @Published public private(set) var spinSession: SlotReelSpinSession?

    /// Optional delegate for lifecycle callbacks.
    public weak var delegate: SlotReelEngineDelegate?

    private var finishedColumnsInSession = Set<Int>()
    private var rollCompletionHandler: (() -> Void)?

    /// Creates a reel engine with layout and animation settings.
    public init(
        configuration: SlotReelConfiguration,
        animationConfiguration: SlotReelAnimationConfiguration = .default,
        initialTopOffsets: [Int]? = nil
    ) {
        self.configuration = configuration
        self.animationConfiguration = animationConfiguration

        let resolvedTopOffsets = initialTopOffsets ?? SlotReelMatrixGenerator.randomInitialTopOffsets(
            columnCount: configuration.columnCount,
            symbolCount: configuration.symbolCount,
            visibleRowCount: configuration.visibleRowCount
        )

        self.columnOffsets = resolvedTopOffsets.map { CGFloat($0) * configuration.itemStride }
        self.symbolOverrides = Array(repeating: [:], count: configuration.columnCount)
    }

    /// Resolves the symbol index for a given absolute item index in a column.
    public func symbolIndex(column: Int, itemIndex: Int) -> Int {
        if let override = symbolOverrides[column][itemIndex] {
            return override
        }
        return normalizedMod(itemIndex, configuration.symbolCount)
    }

    /// Starts a spin using the built-in strict win-line matrix generator.
    public func startRoll(targetSymbolIndex: Int, onComplete: @escaping () -> Void) {
        let matrix = SlotReelMatrixGenerator.generateStrictMatrix(
            targetSymbolIndex: targetSymbolIndex,
            columnCount: configuration.columnCount,
            visibleRowCount: configuration.visibleRowCount,
            symbolCount: configuration.symbolCount
        )
        startRoll(resultMatrix: SlotReelMatrix(values: matrix), onComplete: onComplete)
    }

    /// Starts a spin using a custom result matrix.
    public func startRoll(resultMatrix: SlotReelMatrix, onComplete: @escaping () -> Void) {
        guard !isRolling else { return }
        guard resultMatrix.rowCount >= configuration.visibleRowCount else { return }
        guard resultMatrix.columnCount >= configuration.columnCount else { return }

        isRolling = true
        rollCompletionHandler = onComplete
        finishedColumnsInSession.removeAll()
        symbolOverrides = Array(repeating: [:], count: configuration.columnCount)

        let matrix = resultMatrix.values
        let periodHeight = configuration.cycleHeight
        var normalizedOffsets = columnOffsets
        var plans: [SlotReelSpinPlan] = []

        for column in 0..<configuration.columnCount {
            let currentOffset = columnOffsets[column].truncatingRemainder(dividingBy: periodHeight)
            normalizedOffsets[column] = currentOffset

            let cycles = animationConfiguration.cycleCount(forColumn: column)
            let topSymbol = matrix[0][column]
            let destination = currentOffset + CGFloat(cycles * configuration.symbolCount + topSymbol) * configuration.itemStride
            let snapOffset = (destination / configuration.itemStride).rounded() * configuration.itemStride
            let topItemIndex = Int((destination / configuration.itemStride).rounded())

            var overrides: [Int: Int] = [:]
            for row in 0..<configuration.visibleRowCount {
                overrides[topItemIndex + row] = matrix[row][column]
            }

            plans.append(
                SlotReelSpinPlan(
                    column: column,
                    fromOffset: currentOffset,
                    toOffset: destination,
                    snapOffset: snapOffset,
                    duration: animationConfiguration.duration(forColumn: column),
                    startDelay: animationConfiguration.startDelay(forColumn: column),
                    symbolOverrides: overrides
                )
            )
        }

        columnOffsets = normalizedOffsets
        let session = SlotReelSpinSession(columns: plans)
        spinSession = session
        delegate?.slotReelEngine(self, didStartSpin: session)
    }

    /// Called by column views when a column animation finishes.
    public func markColumnScrollFinished(column: Int, sessionID: UUID) {
        guard let session = spinSession, session.id == sessionID else { return }
        guard let plan = session.plan(for: column) else { return }
        guard !finishedColumnsInSession.contains(column) else { return }

        applyColumnStop(column: column, destination: plan.snapOffset, overrides: plan.symbolOverrides)
        finishedColumnsInSession.insert(column)
        delegate?.slotReelEngine(self, didStopColumn: column, in: session)

        if finishedColumnsInSession.count == configuration.columnCount {
            isRolling = false
            spinSession = nil
            delegate?.slotReelEngine(self, didFinishSpin: session)
            rollCompletionHandler?()
            rollCompletionHandler = nil
        }
    }

    /// Resets all columns to new random non-winning offsets.
    public func resetInitialOffsets() {
        guard !isRolling else { return }
        let topOffsets = SlotReelMatrixGenerator.randomInitialTopOffsets(
            columnCount: configuration.columnCount,
            symbolCount: configuration.symbolCount,
            visibleRowCount: configuration.visibleRowCount
        )
        columnOffsets = topOffsets.map { CGFloat($0) * configuration.itemStride }
        symbolOverrides = Array(repeating: [:], count: configuration.columnCount)
    }

    private func applyColumnStop(column: Int, destination: CGFloat, overrides: [Int: Int]) {
        var nextOffsets = columnOffsets
        nextOffsets[column] = destination
        columnOffsets = nextOffsets

        var nextOverrides = symbolOverrides
        nextOverrides[column] = overrides
        symbolOverrides = nextOverrides
    }

    private func normalizedMod(_ value: Int, _ divisor: Int) -> Int {
        let mod = value % divisor
        return mod >= 0 ? mod : mod + divisor
    }
}
