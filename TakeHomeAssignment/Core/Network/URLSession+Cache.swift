import Foundation

extension URLSession {
	static var `default`: URLSession = URLSession(configuration: makeSessionConfiguration())
}

private func makeSessionConfiguration() -> URLSessionConfiguration {
	let configuration = URLSessionConfiguration.default
	configuration.requestCachePolicy = .returnCacheDataElseLoad
	configuration.httpAdditionalHeaders = ["X-Api-Key": "bc2fc61b-f2d4-4ffa-86af-b2300907a62b"]
	return configuration
}
