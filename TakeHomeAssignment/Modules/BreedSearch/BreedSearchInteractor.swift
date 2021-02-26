import Combine
import Foundation

protocol BreedSearchRouting: AnyObject {
	func routeToBreedDetail(breed: Breed)
}

final class BreedSearchInteractor {
	@Published private(set) var state: State = .idle

	private let breedProvider: BreedProvider
	private weak var router: BreedSearchRouting?

	init(breedProvider: BreedProvider) {
		self.breedProvider = breedProvider
	}

	func start(router: BreedSearchRouting) {
		self.router = router
	}

	func search(for query: String) {
		guard !query.isEmpty else {
			state = .idle
			return
		}

		state = .loading

		breedProvider.searchBreeds(with: query) { [weak self] result in
			switch result {
			case let .success(breeds):
				self?.state = .loaded(breeds)
			case .failure:
				self?.state = .failed
			}
		}
	}

	func selectedBreed(_ breed: Breed) {
		router?.routeToBreedDetail(breed: breed)
	}
}

extension BreedSearchInteractor {
	enum State {
		case loaded([Breed])
		case loading
		case idle
		case failed
	}
}
