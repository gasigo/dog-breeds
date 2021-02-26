import UIKit

extension UIEdgeInsets {
	/// Equal inset from left and right
	static func horizontal(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
	}

	/// Equal inset from top and bottom
	static func vertical(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
	}

	/// Inset from top
	static func top(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
	}

	/// Inset from left
	static func left(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
	}

	/// Inset from bottom
	static func bottom(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
	}

	/// Inset from right
	static func right(_ inset: CGFloat) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
	}
}
