import UIKit

extension UILabel {
	convenience init(text: String?) {
		self.init(frame: .zero)
		self.text = text
	}

	func layout(lines: Int? = nil, alignment: NSTextAlignment? = nil) -> Self {
		lines.map { numberOfLines = $0 }
		alignment.map { textAlignment = $0 }
		return self
	}
}
