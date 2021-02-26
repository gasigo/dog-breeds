import UIKit

extension UIImageView {
	func setImage(with stringURL: String?, placeholder: UIImage? = nil) {
		guard let string = stringURL, let url = URL(string: string) else {
			image = placeholder
			return
		}

		URLSession.default.dataTask(with: url) { data, _, error in
			DispatchQueue.main.async { [weak self] in
				guard let data = data, let image = UIImage(data: data), error == nil else {
					self?.image = placeholder
					return
				}

				self?.image = image
			}
		}.resume()
	}
}
