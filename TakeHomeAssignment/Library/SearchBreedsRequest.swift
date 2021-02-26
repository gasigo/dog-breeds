struct SearchBreedsRequest: RequestData {
	let query: String

	var method: HTTPMethod { .get }
	var path: String { "/breeds/search" }
	var queryParameters: [String: String]? { ["q": query] }
}
