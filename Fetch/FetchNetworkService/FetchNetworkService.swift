import Foundation

final class FetchNetworkService: NetworkService {
    private let session: URLSession
    private let cacheDirectory: URL?

    init(
        session: URLSession,
        cacheDirectory: URL?
    ) {
        self.session = session
        self.cacheDirectory = cacheDirectory
    }

    func sendRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let urlRequest = createRequest(endPoint: endpoint) else {
            throw NetworkError.decodeError
        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: urlRequest) { data, response, _ in
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

    func fetchData(from url: URL) async throws -> URL? {
        if let cacheFile = cachedFileURL(for: url),
           FileManager.default.fileExists(atPath: cacheFile.path) {
            return cacheFile
        }

        let (data, _) = try await session.data(from: url)

        let dataURL = try saveToCache(data: data, for: url)

        return dataURL
    }

    private func createRequest(endPoint: Endpoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        return request
    }

    private func saveToCache(data: Data, for url: URL) throws -> URL? {
        guard let fileURL = cachedFileURL(for: url) else { return nil }
        try data.write(to: fileURL)
        return fileURL
    }

    private func cachedFileURL(for url: URL) -> URL? {
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDirectory?.appendingPathComponent(fileName)
    }
}
