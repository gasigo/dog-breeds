import Combine
import PureLayout
import UIKit

final class BreedSearchViewController: UIViewController {
	private let collectionView: UICollectionView
	private let collectionLayout: UICollectionViewFlowLayout
	private let searchController = UISearchController(searchResultsController: nil)
	private let interactor: BreedSearchInteractor

	private var breeds: [Breed] = []
	private var cancellable = [AnyCancellable]()
	private var currentAttachedView: UIView?

	init(interactor: BreedSearchInteractor) {
		self.interactor = interactor
		self.collectionLayout = UICollectionViewFlowLayout()
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	deinit {
		cancellable.forEach { $0.cancel() }
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
		setupSearchBar()

		interactor.$state
			.sink { [weak self] state in
				DispatchQueue.main.async {
					self?.updateUI(with: state)
				}
			}
			.store(in: &cancellable)

		NotificationCenter.default.publisher(
			for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField
		)
			.compactMap {
				($0.object as? UISearchTextField)?.text
			}
			.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
			.sink { [weak self] text in
				self?.interactor.search(for: text)
			}
			.store(in: &cancellable)
	}

	private func setupCollectionView() {
		collectionLayout.minimumInteritemSpacing = 20
		collectionLayout.minimumLineSpacing = 20
		collectionView.backgroundColor = .white
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.showsVerticalScrollIndicator = false
		collectionView.register(BreedCell.self, forCellWithReuseIdentifier: "BreedCell")
	}

	private func setupSearchBar() {
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search dog breeds"
		searchController.searchBar.searchTextField.backgroundColor = .systemBackground
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	private func updateUI(with state: BreedSearchInteractor.State) {
		switch state {
		case let .loaded(sessions):
			displayBreedList(sessions)
		case .loading:
			displayLoadingState()
		case .idle:
			displayIdleState()
		case .failed:
			displayErrorState()
		}
	}

	private func displayBreedList(_ breeds: [Breed]) {
		self.breeds = breeds
		attachView(collectionView)
		collectionView.reloadData()
	}

	private func displayLoadingState() {
		attachView(LoadingView())
	}

	private func displayIdleState() {
		attachView(MessageView(message: "Type the name of the breed you're looking for."))
	}

	private func displayErrorState() {
		attachView(MessageView(message: "Ops! Something went wrong!"))
	}

	private func attachView(_ content: UIView) {
		currentAttachedView?.removeFromSuperview()
		view.insertSubview(content, at: 0)
		content.autoPin(toTopLayoutGuideOf: self)
		content.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
		currentAttachedView = content
	}
}

extension BreedSearchViewController:
	UICollectionViewDataSource,
	UICollectionViewDelegate,
	UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		breeds.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		guard
			let cell = collectionView.dequeueReusableCell(
				withReuseIdentifier: "BreedCell", for: indexPath
			) as? BreedCell
		else {
			return UICollectionViewCell()
		}

		cell.configure(with: breeds[indexPath.item])
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		interactor.selectedBreed(breeds[indexPath.item])
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let size = collectionView.bounds.width / 2
		return CGSize(width: size - 20, height: size)
	}
}

private final class LoadingView: UIView {
	init() {
		super.init(frame: .zero)

		backgroundColor = .white

		let spinner = UIActivityIndicatorView(style: .large)
		spinner.color = .black
		spinner.startAnimating()

		addSubview(spinner)
		spinner.autoCenterInSuperview()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private final class MessageView: UIView {
	init(message: String) {
		super.init(frame: .zero)

		backgroundColor = .white

		let stack = UIStackView()
			.containing([UILabel(text: message).layout(lines: 0, alignment: .center)])
			.configured(axis: .vertical)
			.with(margins: .horizontal(10), spacing: 10)

		addSubview(stack)
		stack.autoCenterInSuperview()
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
