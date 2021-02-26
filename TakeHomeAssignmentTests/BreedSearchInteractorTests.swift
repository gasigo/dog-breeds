import XCTest
@testable import TakeHomeAssignment

final class BreedSearchInteractorTests: XCTestCase {
	private var routerSpy: BreedSearchRouterSpy!
	private var breedProviderSpy: BreedProviderSpy!
	private var sut: BreedSearchInteractor!

	private let dummyBreed = Breed(
		name: "Name",
		lifespan: "10-12",
		temperament: "Calm",
		group: "Work",
		imageURL: "lyst.co.uk"
	)

	override func setUp() {
		routerSpy = BreedSearchRouterSpy()
		breedProviderSpy = BreedProviderSpy()
		sut = BreedSearchInteractor(breedProvider: breedProviderSpy)
	}
}

// MARK: - Start Tests

extension BreedSearchInteractorTests {
	func testStart_givenStartIsCalled_thenRouterIsSet() {
		// given
		sut.start(router: routerSpy)

		// when
		sut.selectedBreed(dummyBreed)

		// then
		XCTAssertEqual(routerSpy.routeToBreedDetailCounter, 1)
	}
}

// MARK: - Search Tests

extension BreedSearchInteractorTests {
	func testSearch_givenResponseIsSuccess_thenProviderIsCalledAndStateIsLoaded() {
		// given
		let query = "test"
		breedProviderSpy.searchBreedsResponse = .success([dummyBreed])

		// when
		sut.search(for: query)

		// then
		XCTAssertEqual(breedProviderSpy.searchBreedsCounter, 1)
		XCTAssertEqual(sut.state, .loaded([dummyBreed]))
	}

	func testSearch_givenQueryIsNotEmpty_thenProviderIsCalledAndStateIsLoading() {
		// given
		let query = "test"

		// when
		sut.search(for: query)

		// then
		XCTAssertEqual(breedProviderSpy.searchBreedsCounter, 1)
		XCTAssertEqual(sut.state, .loading)
	}

	func testSearch_givenResponseIsError_thenProviderIsCalledAndStateIsFailed() {
		// given
		let query = "test"
		breedProviderSpy.searchBreedsResponse = .failure(DummyError.test)

		// when
		sut.search(for: query)

		// then
		XCTAssertEqual(breedProviderSpy.searchBreedsCounter, 1)
		XCTAssertEqual(sut.state, .failed)
	}

	func testSearch_givenQueryIsEmpty_thenProviderIsNotCalledAndStateIsIdle() {
		// given
		let query = ""

		// when
		sut.search(for: query)

		// then
		XCTAssertEqual(breedProviderSpy.searchBreedsCounter, 0)
		XCTAssertEqual(sut.state, .idle)
	}
}

// MARK: - Selected Breed Tests

extension BreedSearchInteractorTests {
	func testSelectedBreed_givenRouterIsSet_thenRouteToBreedDetailIsCalled() {
		// given
		sut.start(router: routerSpy)

		// when
		sut.selectedBreed(dummyBreed)

		// then
		XCTAssertEqual(routerSpy.routeToBreedDetailCounter, 1)
		XCTAssertEqual(dummyBreed, routerSpy.capturedBreed)
	}
}

final class BreedSearchRouterSpy: BreedSearchRouting {
	var routeToBreedDetailCounter = 0
	var capturedBreed: Breed?
	func routeToBreedDetail(breed: Breed) {
		routeToBreedDetailCounter += 1
		capturedBreed = breed
	}
}

final class BreedProviderSpy: BreedProvider {
	var searchBreedsCounter = 0
	var searchBreedsResponse: Result<[Breed], Error>?
	func searchBreeds(with query: String, handler: @escaping (Result<[Breed], Error>) -> Void) {
		searchBreedsCounter += 1

		if let result = searchBreedsResponse {
			handler(result)
		}
	}
}

extension BreedSearchInteractor.State: Equatable {
	public static func == (lhs: BreedSearchInteractor.State, rhs: BreedSearchInteractor.State) -> Bool {
		switch (lhs, rhs) {
		case (.loaded, .loaded):
			return true
		case (.loading, .loading):
			return true
		case (.idle, .idle):
			return true
		case (.failed, .failed):
			return true
		default:
			return false
		}
	}
}

enum DummyError: Error {
	case test
}
