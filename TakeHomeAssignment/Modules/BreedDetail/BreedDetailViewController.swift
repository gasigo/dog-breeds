import Combine
import PureLayout
import UIKit

final class BreedDetailViewController: UIViewController {
	private let breed: Breed

	init(breed: Breed) {
		self.breed = breed
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func viewDidLoad() {
		super.viewDidLoad()
		displayContentView(breed: breed)
	}

	private func displayContentView(breed: Breed) {
		attachView(ContentView(breed: breed))
	}

	private func attachView(_ content: UIView) {
		view.insertSubview(content, at: 0)
		content.autoPin(toTopLayoutGuideOf: self)
		content.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
	}
}

private final class ContentView: UIView {
	init(breed: Breed) {
		super.init(frame: .zero)

		backgroundColor = .white

		let breedImage = UIImageView(frame: .zero)
		breedImage.setImage(with: breed.imageURL, placeholder: UIImage(named: "breed_placeholder"))
		breedImage.contentMode = .scaleAspectFit

		let name = UILabel(text: "Name: " + breed.name).layout(lines: 0)
		let lifespan = UILabel(text: "Lifespan: " + breed.lifespan).layout(lines: 0)

		let temperament = UILabel(
			text: "Temperament: " + (breed.temperament ?? "No temperament information available")
		).layout(lines: 0)

		let groupLabel = UILabel(
			text: "Breed group: " + (breed.group ?? "No breed group information available")
		).layout(lines: 0)

		let stack = UIStackView()
			.containing([name, lifespan, temperament, groupLabel])
			.configured(axis: .vertical)
			.with(margins: .horizontal(20), spacing: 10)
		addSubview(breedImage)
		addSubview(stack)

		breedImage.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
		breedImage.autoSetDimension(.height, toSize: 287)
		stack.autoPinEdge(toSuperviewEdge: .left)
		stack.autoPinEdge(toSuperviewEdge: .right)
		stack.autoPinEdge(.top, to: .bottom, of: breedImage, withOffset: 10)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
