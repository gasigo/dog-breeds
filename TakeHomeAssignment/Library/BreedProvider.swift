protocol BreedProvider {
	func searchBreeds(with query: String, handler: @escaping (Result<[Breed], Error>) -> Void)
}

final class BreedProviderImpl: BreedProvider {
	private let networkService: NetworkService

	init(networkService: NetworkService) {
		self.networkService = networkService
	}

	func searchBreeds(with query: String, handler: @escaping (Result<[Breed], Error>) -> Void) {
		networkService.request(data: SearchBreedsRequest(query: query), responseType: [Breed].self) { result in
			switch result {
			case let .success(breeds):
				handler(.success(breeds))
			case let .failure(error):
				handler(.failure(error))
			}
		}
	}
}
