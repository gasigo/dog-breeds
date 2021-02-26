import UIKit

protocol BreedSearchComponent {
	var window: UIWindow { get }
	var navigationController: UINavigationController { get }
	var breedProvider: BreedProvider { get }
}

struct BreedSearchBuilder {
	func build(component: BreedSearchComponent) -> BreedSearchRouter {
		let interactor = BreedSearchInteractor(breedProvider: component.breedProvider)
		let viewController = BreedSearchViewController(interactor: interactor)

		return BreedSearchRouter(
			interactor: interactor,
			presentedViewController: viewController,
			component: component
		)
	}
}
