import Foundation

protocol NetworkService {
	func request<T: Decodable>(
		data: RequestData,
		responseType: T.Type,
		handler: @escaping (Result<T, Error>) -> Void
	)
}

final class NetworkServiceImpl: NetworkService {
	private let host = "https://api.thedogapi.com/v1"
	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	func request<T: Decodable>(
		data: RequestData,
		responseType: T.Type,
		handler: @escaping (Result<T, Error>) -> Void
	) {
		guard let url = URL(string: host + data.path)?.append(queryParameters: data.queryParameters) else {
			handler(.failure(NetworkError.invalidURL))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = data.method.rawValue

		session.dataTask(with: request) { [weak self] data, _, error in
			switch (data, error) {
			case let (_, .some(error)):
				handler(.failure(error))
			case let (.some(data), .none):
				guard let response = self?.decode(data: data, to: responseType) else {
					fallthrough
				}

				handler(.success(response))
			default:
				handler(.failure(NetworkError.unableToSerialize))
			}
		}.resume()
	}

	private func decode<T: Decodable>(data: Data, to type: T.Type) -> T? {
		do {
			return try JSONDecoder().decode(type, from: data)
		} catch {
			print(error)
		}

		return nil
	}
}

private extension URL {
	func append(queryParameters: [String: String]?) -> URL? {
		guard
			let queryParameters = queryParameters,
			var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)
		else {
			return self
		}

		var mutableQueryItems: [URLQueryItem] = urlComponents.queryItems ?? []
		mutableQueryItems.append(contentsOf: queryParameters.map { URLQueryItem(name: $0, value: $1) })
		urlComponents.queryItems = mutableQueryItems
		return urlComponents.url
	}
}
