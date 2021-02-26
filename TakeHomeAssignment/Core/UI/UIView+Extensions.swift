import UIKit

extension UIView {
	@discardableResult
	func autoPin(
		toTopLayoutGuideOf viewController: UIViewController,
		withInset: CGFloat = 0,
		relation: NSLayoutConstraint.Relation = .equal,
		priority: UILayoutPriority = .required
	) -> NSLayoutConstraint {
		translatesAutoresizingMaskIntoConstraints = false
		let constraint = NSLayoutConstraint(
			item: self,
			attribute: .top,
			relatedBy: relation,
			toItem: viewController.view.safeAreaLayoutGuide,
			attribute: .top,
			multiplier: 1,
			constant: withInset
		)
		constraint.priority = priority
		constraint.isActive = true
		return constraint
	}
}
