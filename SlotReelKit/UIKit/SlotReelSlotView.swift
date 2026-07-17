//
//  SlotReelSlotView.swift
//  SlotReelKit
//
//  UIKit view representing one symbol slot in a reel column.
//

import UIKit

/// Renders a single symbol cell with gradient background and optional border.
final class SlotReelSlotView: UIView {
    private let backgroundGradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let borderLayer = CALayer()
    private let symbolImageView = UIImageView()
    private var appearance: SlotReelAppearanceConfiguration

    /// Creates a slot view with the given appearance configuration.
    init(appearance: SlotReelAppearanceConfiguration) {
        self.appearance = appearance
        super.init(frame: .zero)
        configureViews()
        applyAppearance()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradientView.frame = bounds
        gradientLayer.frame = backgroundGradientView.bounds
        borderLayer.frame = backgroundGradientView.bounds
        symbolImageView.bounds = CGRect(origin: .zero, size: appearance.symbolSize)
        symbolImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    /// Updates appearance styling.
    func updateAppearance(_ appearance: SlotReelAppearanceConfiguration) {
        self.appearance = appearance
        applyAppearance()
        setNeedsLayout()
    }

    /// Configures the displayed symbol image.
    func configure(symbolIndex: Int) {
        symbolImageView.image = appearance.image(forSymbolIndex: symbolIndex)
    }

    private func configureViews() {
        clipsToBounds = true
        addSubview(backgroundGradientView)
        backgroundGradientView.layer.addSublayer(gradientLayer)
        backgroundGradientView.layer.addSublayer(borderLayer)
        symbolImageView.contentMode = .scaleAspectFit
        addSubview(symbolImageView)
    }

    private func applyAppearance() {
        layer.cornerRadius = appearance.slotCornerRadius
        layer.masksToBounds = true
        gradientLayer.colors = [
            appearance.slotGradientTopColor.cgColor,
            appearance.slotGradientBottomColor.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        borderLayer.borderColor = appearance.slotBorderColor.cgColor
        borderLayer.borderWidth = appearance.slotBorderWidth
        borderLayer.cornerRadius = max(0, appearance.slotCornerRadius - 8)
    }
}
