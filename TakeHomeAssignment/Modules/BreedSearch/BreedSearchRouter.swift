import UIKit

final class BreedSearchRouter: BreedSearchRouting {
	private let interactor: BreedSearchInteractor
	private let presentedViewController: UIViewController
	private let component: BreedSearchComponent

	init(
		interactor: BreedSearchInteractor,
		presentedViewController: UIViewController,
		component: BreedSearchComponent
	) {
		self.interactor = interactor
		self.presentedViewController = presentedViewController
		self.component = component
	}

	func start() {
		interactor.start(router: self)
		component.navigationController.viewControllers = [presentedViewController]
		component.window.rootViewController = component.navigationController
		component.window.makeKeyAndVisible()
	}

	func routeToBreedDetail(breed: Breed) {
		let detailVC = BreedDetailViewController(breed: breed)
		component.navigationController.pushViewController(detailVC, animated: true)
	}
}
