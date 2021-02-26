import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	private var rootRouter: BreedSearchRouter?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = (scene as? UIWindowScene) else { return }

		let window = UIWindow(windowScene: windowScene)
		rootRouter = buildApplicationTree(window: window)
		self.window = window
	}
}

extension SceneDelegate {
	func buildApplicationTree(window: UIWindow) -> BreedSearchRouter {
		let router = BreedSearchBuilder().build(component: BreedSearchComponentImpl(window: window))
		router.start()

		return router
	}
}
