//
//  SliderButton
//
//  Created by Noman belim
//

import Foundation
import UIKit
 
public final class CallSliderView: UIView {

    // 🔹 Public callback
    public var onSlideCompleted: ((SlideDirection) -> Void)?

    // 🔹 Stored result
    public private(set) var slideDirection: SlideDirection = .none

    // 🔹 Configurable properties (set later)
    private var rightSliderColor: UIColor = .green
    private var leftSliderColor: UIColor = .red
    private var centerSliderColor: UIColor = .orange
    private var knobImage: UIImage?

    private let knobSize: CGFloat = 70
    private let knobView = UIImageView()

    private var maxOffset: CGFloat = 0
    private var centerX: CGFloat = 0

    // ✅ REQUIRED for storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // 🔹 Configure from ViewController
    public func configure(
        rightColor: UIColor,
        leftColor: UIColor,
        centerColor: UIColor,
        icon: UIImage?
    ) {
        self.rightSliderColor = rightColor
        self.leftSliderColor = leftColor
        self.centerSliderColor = centerColor
        self.knobImage = icon

        knobView.image = icon
        knobView.backgroundColor = centerColor
    }

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        layer.cornerRadius = knobSize / 2

        knobView.tintColor = .white
        knobView.contentMode = .center
        knobView.layer.cornerRadius = knobSize / 2
        knobView.isUserInteractionEnabled = true

        addSubview(knobView)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        knobView.addGestureRecognizer(pan)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        centerX = (bounds.width - knobSize) / 2
        maxOffset = centerX

        if knobView.frame == .zero {
            knobView.frame = CGRect(
                x: centerX,
                y: 0,
                width: knobSize,
                height: knobSize
            )
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        let x = min(
            max(centerX - maxOffset, centerX + translation.x),
            centerX + maxOffset
        )

        knobView.frame.origin.x = x
        updateColorLive()

        if gesture.state == .ended {
            finalizeDirection()
            onSlideCompleted?(slideDirection)
            reset()
        }
    }

    private func updateColorLive() {
        let delta = knobView.frame.origin.x - centerX

        if delta > 5 {
            knobView.backgroundColor = rightSliderColor
        } else if delta < -5 {
            knobView.backgroundColor = leftSliderColor
        } else {
            knobView.backgroundColor = centerSliderColor
        }
    }

    private func finalizeDirection() {
        let delta = knobView.frame.origin.x - centerX

        if delta > maxOffset * 0.8 {
            slideDirection = .right
        } else if delta < -maxOffset * 0.8 {
            slideDirection = .left
        } else {
            slideDirection = .none
        }
    }

    private func reset() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.6
        ) {
            self.knobView.frame.origin.x = self.centerX
            self.knobView.backgroundColor = self.centerSliderColor
        }
    }
}
 

public final class GooglePaySliderView: UIView {

    public private(set) var paymentStatus: PaymentStatus = .pending
    public var onPaymentCompleted: ((PaymentStatus) -> Void)?

    // 🔹 Stored config
    private var sliderColor: UIColor = .systemGreen
    private var titleText: String = "Slide to Pay"

    private let knobSize: CGFloat = 56
    private let knobView = UIView()
    private let titleLabel = UILabel()

    private var maxOffset: CGFloat = 0
    private var isConfigured = false

    // ✅ Required for storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public func configure(sliderColor: UIColor, text: String) {
        self.sliderColor = sliderColor
        self.titleText = text
        isConfigured = true
        setNeedsLayout() // 🔥 wait for layout safely
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = knobSize / 2

        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)
        addSubview(titleLabel)

        knobView.layer.cornerRadius = knobSize / 2
        knobView.isUserInteractionEnabled = true
        addSubview(knobView)

        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .white
        arrow.frame = CGRect(x: 0, y: 0, width: knobSize, height: knobSize)
        arrow.contentMode = .center
        knobView.addSubview(arrow)

        knobView.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = bounds
        maxOffset = bounds.width - knobSize

        if knobView.frame == .zero {
            knobView.frame = CGRect(x: 0, y: 0, width: knobSize, height: knobSize)
        }

        applyConfiguration()
    }

    private func applyConfiguration() {
        guard isConfigured else { return }

        backgroundColor = sliderColor.withAlphaComponent(0.15)
        titleLabel.text = titleText
        titleLabel.textColor = sliderColor
        knobView.backgroundColor = sliderColor
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let x = min(max(0, translation.x), maxOffset)
        knobView.frame.origin.x = x

        if gesture.state == .ended {
            if x > maxOffset * 0.9 {
                paymentStatus = .done
                onPaymentCompleted?(paymentStatus)
            }
            reset()
        }
    }

    private func reset() {
        UIView.animate(withDuration: 0.3) {
            self.knobView.frame.origin.x = 0
        }
    }
}
