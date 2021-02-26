import UIKit

struct BreedSearchComponentImpl: BreedSearchComponent {
	let window: UIWindow
	let navigationController: UINavigationController = UINavigationController()

	var breedProvider: BreedProvider {
		BreedProviderImpl(networkService: NetworkServiceImpl(session: .default))
	}
}
