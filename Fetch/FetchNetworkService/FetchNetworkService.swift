import Foundation

final class FetchNetworkService: NetworkService {
    private func createRequest(endPoint: Endpoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        guard let url = urlComponents.url else {
            return nil
        }
        let encoder = JSONEncoder()
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        return request
    }

    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            throw NetworkError.decodeError
        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                .dataTask(with: urlRequest) { data, response, _ in
                    guard response is HTTPURLResponse else {
                        continuation.resume(throwing: NetworkError.invalidURL)
                        return
                    }
                    guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                        continuation.resume(throwing: NetworkError.invalidStatusCode)
                        return
                    }
                    guard let data = data else {
                        continuation.resume(throwing: NetworkError.noData)
                        return
                    }

                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decodedResponse)
                        return
                    } catch {
                        continuation.resume(throwing: NetworkError.decodeError)
                        print("DECODING ERROR: \(error)")
                        return
                    }
                }
            task.resume()
        }
    }
}
