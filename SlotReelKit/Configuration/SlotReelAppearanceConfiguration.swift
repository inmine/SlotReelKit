//
//  SlotReelAppearanceConfiguration.swift
//  SlotReelKit
//
//  Visual styling configuration for reel slots and container.
//

import UIKit

/// Provides symbol images for reel cells.
public protocol SlotReelSymbolImageProviding: AnyObject {
    /// Returns the image for the given zero-based symbol index.
    func image(forSymbolIndex index: Int) -> UIImage?
}

/// Closure-based image provider for lightweight integration.
public typealias SlotReelSymbolImageProvider = (Int) -> UIImage?

/// Defines colors, corner radii, and symbol rendering for the reel UI.
public struct SlotReelAppearanceConfiguration {
    /// Background color of the outer reel container.
    public var containerBackgroundColor: UIColor

    /// Corner radius of the outer container.
    public var containerCornerRadius: CGFloat

    /// Top gradient color of each symbol slot.
    public var slotGradientTopColor: UIColor

    /// Bottom gradient color of each symbol slot.
    public var slotGradientBottomColor: UIColor

    /// Corner radius of each symbol slot.
    public var slotCornerRadius: CGFloat

    /// Inner border color drawn inside each slot.
    public var slotBorderColor: UIColor

    /// Inner border width drawn inside each slot.
    public var slotBorderWidth: CGFloat

    /// Display size of the symbol image inside a slot.
    public var symbolSize: CGSize

    /// Object-based image provider. Takes precedence when set.
    public weak var symbolImageProvider: SlotReelSymbolImageProviding?

    /// Closure-based image provider used when `symbolImageProvider` is nil.
    public var symbolImageProviderClosure: SlotReelSymbolImageProvider?

    /// Creates an appearance configuration.
    public init(
        containerBackgroundColor: UIColor = UIColor(red: 0.369, green: 0.157, blue: 0.149, alpha: 1),
        containerCornerRadius: CGFloat = 20,
        slotGradientTopColor: UIColor = UIColor(red: 0.988, green: 0.882, blue: 0.529, alpha: 1),
        slotGradientBottomColor: UIColor = UIColor(red: 0.976, green: 0.678, blue: 0.031, alpha: 1),
        slotCornerRadius: CGFloat = 12,
        slotBorderColor: UIColor = UIColor.black.withAlphaComponent(0.1),
        slotBorderWidth: CGFloat = 1,
        symbolSize: CGSize = CGSize(width: 48, height: 48),
        symbolImageProvider: SlotReelSymbolImageProviding? = nil,
        symbolImageProviderClosure: SlotReelSymbolImageProvider? = nil
    ) {
        self.containerBackgroundColor = containerBackgroundColor
        self.containerCornerRadius = containerCornerRadius
        self.slotGradientTopColor = slotGradientTopColor
        self.slotGradientBottomColor = slotGradientBottomColor
        self.slotCornerRadius = slotCornerRadius
        self.slotBorderColor = slotBorderColor
        self.slotBorderWidth = slotBorderWidth
        self.symbolSize = symbolSize
        self.symbolImageProvider = symbolImageProvider
        self.symbolImageProviderClosure = symbolImageProviderClosure
    }

    /// Resolves the symbol image for a given index using the configured providers.
    public func image(forSymbolIndex index: Int) -> UIImage? {
        if let provider = symbolImageProvider {
            return provider.image(forSymbolIndex: index)
        }
        return symbolImageProviderClosure?(index)
    }
}
