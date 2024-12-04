protocol NetworkService {
    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T
}
