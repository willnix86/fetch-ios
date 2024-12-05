import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let mockResponse = MockURLProtocol.mockResponses[url] {
            if let error = mockResponse.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let response = mockResponse.response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                if let data = mockResponse.data {
                    client?.urlProtocol(self, didLoad: data)
                }
                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }

    override func stopLoading() {}
}
