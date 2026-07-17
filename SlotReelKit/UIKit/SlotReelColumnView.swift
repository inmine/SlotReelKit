//
//  SlotReelColumnView.swift
//  SlotReelKit
//
//  UIKit column view with circular slot rendering and CADisplayLink animation.
//

import UIKit

/// A single reel column that scrolls symbols vertically using fixed slot views.
public final class SlotReelColumnView: UIView {
    private let configuration: SlotReelConfiguration
    private var appearance: SlotReelAppearanceConfiguration
    private var animationConfiguration: SlotReelAnimationConfiguration
    private let slotViews: [SlotReelSlotView]

    private var symbolOverrides: [Int: Int] = [:]
    private var displayOffset: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var animationFromOffset: CGFloat = 0
    private var animationToOffset: CGFloat = 0
    private var animationStartTime: CFTimeInterval = 0
    private var animationDuration: TimeInterval = 0
    private var animationCompletion: (() -> Void)?
    private var pendingAnimationWorkItem: DispatchWorkItem?

    /// Creates a column view.
    public init(
        configuration: SlotReelConfiguration,
        appearance: SlotReelAppearanceConfiguration,
        animationConfiguration: SlotReelAnimationConfiguration = .default
    ) {
        self.configuration = configuration
        self.appearance = appearance
        self.animationConfiguration = animationConfiguration
        self.slotViews = (0..<configuration.renderedRowCount).map { _ in
            SlotReelSlotView(appearance: appearance)
        }
        super.init(frame: .zero)
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    deinit {
        stopDisplayLink()
    }

    /// Sets the vertical content offset without animation.
    public func setContentOffset(_ offset: CGFloat, animated: Bool) {
        displayOffset = max(0, offset)
        updateSlotLayout()
    }

    /// Updates symbol overrides for stopped results.
    public func updateSymbolOverrides(_ overrides: [Int: Int]) {
        symbolOverrides = overrides
        updateSlotLayout()
    }

    /// Updates visual appearance at runtime.
    public func updateAppearance(_ appearance: SlotReelAppearanceConfiguration) {
        self.appearance = appearance
        slotViews.forEach { $0.updateAppearance(appearance) }
        updateSlotLayout()
    }

    /// Cancels any pending or active animation.
    public func cancelPendingAnimation() {
        pendingAnimationWorkItem?.cancel()
        pendingAnimationWorkItem = nil
        stopDisplayLink()
    }

    /// Runs a column spin using the provided plan.
    public func runSpinAnimation(plan: SlotReelSpinPlan, completion: @escaping () -> Void) {
        cancelPendingAnimation()
        displayOffset = plan.fromOffset
        updateSlotLayout()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.startDisplayLinkAnimation(
                from: plan.fromOffset,
                to: plan.toOffset,
                duration: plan.duration,
                completion: { [weak self] in
                    guard let self else { return }
                    self.displayOffset = plan.snapOffset
                    self.symbolOverrides = plan.symbolOverrides
                    self.updateSlotLayout()
                    completion()
                }
            )
        }

        pendingAnimationWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + plan.startDelay, execute: workItem)
    }

    @objc private func handleDisplayLinkTick(_ link: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - animationStartTime
        let linearProgress = min(1, elapsed / animationDuration)
        let easedProgress = animationConfiguration.easing.value(at: linearProgress)
        displayOffset = animationFromOffset + (animationToOffset - animationFromOffset) * CGFloat(easedProgress)
        updateSlotLayout()

        guard linearProgress >= 1 else { return }
        stopDisplayLink()
        displayOffset = animationToOffset
        updateSlotLayout()
        animationCompletion?()
        animationCompletion = nil
    }

    private func configureView() {
        clipsToBounds = true
        slotViews.forEach { addSubview($0) }
        updateSlotLayout()
    }

    private func updateSlotLayout() {
        let stride = configuration.itemStride
        let buffer = configuration.renderBufferRows
        let baseIndex = Int(floor(displayOffset / stride))
        let fractionalOffset = displayOffset - CGFloat(baseIndex) * stride
        let startIndex = baseIndex - buffer

        for slot in slotViews.indices {
            let itemIndex = startIndex + slot
            slotViews[slot].configure(symbolIndex: symbolIndex(for: itemIndex))
            slotViews[slot].frame = CGRect(
                x: 0,
                y: CGFloat(slot) * stride - fractionalOffset,
                width: configuration.cellWidth,
                height: configuration.cellHeight
            )
        }
    }

    private func symbolIndex(for itemIndex: Int) -> Int {
        if let override = symbolOverrides[itemIndex] {
            return override
        }
        let mod = itemIndex % configuration.symbolCount
        return mod >= 0 ? mod : mod + configuration.symbolCount
    }

    private func startDisplayLinkAnimation(
        from: CGFloat,
        to: CGFloat,
        duration: TimeInterval,
        completion: @escaping () -> Void
    ) {
        stopDisplayLink()
        animationFromOffset = from
        animationToOffset = to
        animationDuration = duration
        animationStartTime = CACurrentMediaTime()
        animationCompletion = completion

        let link = CADisplayLink(target: self, selector: #selector(handleDisplayLinkTick(_:)))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
