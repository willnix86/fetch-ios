import Foundation

protocol NetworkService {
    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T
    func fetchData(from url: URL) async throws -> URL?
}
