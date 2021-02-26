import UIKit

final class BreedCell: UICollectionViewCell {
	private let content = BreedCellContentView()

	override init(frame: CGRect) {
		super.init(frame: frame)

		contentView.addSubview(content)
		content.autoPinEdgesToSuperviewEdges()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func prepareForReuse() {
		content.thumbnailImageView.image = nil
		super.prepareForReuse()
	}

	func configure(with breed: Breed) {
		content.configure(with: breed)
	}
}

private final class BreedCellContentView: UIView {
	let nameLabel = UILabel().layout(lines: 0, alignment: .center)
	let thumbnailImageView = UIImageView()

	init() {
		super.init(frame: .zero)
		thumbnailImageView.backgroundColor = .white
		thumbnailImageView.contentMode = .scaleAspectFit
		addSubview(thumbnailImageView)

		let stack = UIStackView()
			.containing([thumbnailImageView, nameLabel])
			.configured(axis: .vertical)
			.with(margins: .horizontal(10), spacing: 10)
		addSubview(stack)

		thumbnailImageView.autoSetDimension(.height, toSize: 123)
		stack.autoPinEdgesToSuperviewEdges()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	func configure(with breed: Breed) {
		nameLabel.text = breed.name
		thumbnailImageView.setImage(with: breed.imageURL, placeholder: UIImage(named: "breed_placeholder"))
	}
}
