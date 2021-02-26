import UIKit

extension UIStackView {
	func containing(_ views: [UIView]) -> Self {
		for subview in arrangedSubviews {
			removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}

		for subview in views {
			addArrangedSubview(subview)
		}
		return self
	}

	func configured(
		axis: NSLayoutConstraint.Axis? = nil,
		alignment: UIStackView.Alignment? = nil,
		distribution: UIStackView.Distribution? = nil
	) -> Self {
		axis.map { self.axis = $0 }
		alignment.map { self.alignment = $0 }
		distribution.map { self.distribution = $0 }
		return self
	}

	func with(
		margins: UIEdgeInsets? = nil,
		relativeToSafeArea: Bool = true,
		spacing: CGFloat? = nil
	) -> Self {
		if let margins = margins {
			isLayoutMarginsRelativeArrangement = true
			layoutMargins = margins
			insetsLayoutMarginsFromSafeArea = relativeToSafeArea
		}
		spacing.map { self.spacing = $0 }
		return self
	}
}
