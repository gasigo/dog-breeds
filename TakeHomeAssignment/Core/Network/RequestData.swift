enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

protocol RequestData {
	var method: HTTPMethod { get }
	var path: String { get }
	var queryParameters: [String: String]? { get }
}
