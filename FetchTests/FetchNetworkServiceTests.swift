import XCTest
@testable import Fetch

final class FetchNetworkServiceTests: XCTestCase {
    var networkService: FetchNetworkService!
    var mockSession: URLSession!
    var mockCacheDirectory: URL!

    let endpoint: Endpoint = FetchEndpoint.recipes
    let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net\(FetchEndpoint.recipes.path)")!

    override func setUp() {
        super.setUp()

        mockCacheDirectory = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(UUID().uuidString)

        try? FileManager.default.createDirectory(
            at: mockCacheDirectory,
            withIntermediateDirectories: true
        )

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)

        networkService = FetchNetworkService(
            session: mockSession,
            cacheDirectory: mockCacheDirectory
        )
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: mockCacheDirectory)

        networkService = nil
        mockSession = nil
        mockCacheDirectory = nil

        super.tearDown()
    }

    func test_sendRequest_success() async throws {
        let jsonData = try! JSONEncoder().encode(
            RecipeListDto(recipes: [
                RecipeDto(
                    cuisine: "British",
                    name: "Test",
                    photoURLLarge: nil,
                    photoURLSmall: nil,
                    uuid: "1",
                    sourceURL: nil,
                    youtubeURL: nil
                )
            ])
        )

        MockURLProtocol.mockResponses[url] = (
            data: jsonData,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let result: RecipeListDto = try await networkService.sendRequest(
            endpoint: endpoint
        )

        XCTAssertEqual(result.recipes.first!.uuid, "1")
        XCTAssertEqual(result.recipes.first!.name, "Test")
    }

    func test_sendRequest_success_withEmptyRecipes() async throws {
        let jsonData = try! JSONEncoder().encode(
            RecipeListDto(recipes: [])
        )

        MockURLProtocol.mockResponses[url] = (
            data: jsonData,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let result: RecipeListDto = try await networkService.sendRequest(
            endpoint: endpoint
        )

        XCTAssertTrue(result.recipes.isEmpty)
    }

    func test_sendRequest_emitsNoResponseError() async {
        MockURLProtocol.mockResponses[url] = (
            data: nil,
            response: nil,
            error: nil
        )

        do {
            let _: RecipeDto = try await networkService.sendRequest(
                endpoint: endpoint
            )
            XCTFail("Should throw no response error")
        } catch NetworkError.noResponse {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_sendRequest_emitsStatusCodeError() async {
        MockURLProtocol.mockResponses[url] = (
            data: nil,
            response: HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        do {
            let _: RecipeDto = try await networkService.sendRequest(
                endpoint: endpoint
            )
            XCTFail("Should throw invalid status code error")
        } catch NetworkError.invalidStatusCode {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_sendRequest_emitsFailedToCreateRequestError() async {
        struct InvalidEndpoint: Endpoint {
            var scheme: String { "" }
            var host: String { "" }
            var path: String { "/invalid" }
            var method: RequestMethod { .get }
        }

        MockURLProtocol.mockResponses[url] = (
            data: nil,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        do {
            let _: RecipeDto = try await networkService.sendRequest(
                endpoint: InvalidEndpoint()
            )
            XCTFail("Should throw failed to create request error")
        } catch NetworkError.failedToCreateRequest {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_sendRequest_emitsNoDataError() async {
        MockURLProtocol.mockResponses[url] = (
            data: nil,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        do {
            let _: RecipeDto = try await networkService.sendRequest(
                endpoint: endpoint
            )
            XCTFail("Should throw invalid url error")
        } catch NetworkError.noData {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_sendRequest_emitsDecodingError() async {
        let mockData = "Invalid JSON".data(using: .utf8)!

        MockURLProtocol.mockResponses[url] = (
            data: mockData,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        do {
            let _: RecipeDto = try await networkService.sendRequest(
                endpoint: endpoint
            )
            XCTFail("Should throw decoding error")
        } catch NetworkError.decodeError {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_caching() async throws {
        let mockData = "Invalid JSON".data(using: .utf8)!

        MockURLProtocol.mockResponses[url] = (
            data: mockData,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let firstCachedURL = try await networkService.fetchData(from: url)

        XCTAssertNotNil(firstCachedURL)
        XCTAssertTrue(FileManager.default.fileExists(atPath: firstCachedURL!.path))

        let secondCachedURL = try await networkService.fetchData(from: url)

        XCTAssertEqual(firstCachedURL, secondCachedURL)

        let cachedData = try Data(contentsOf: firstCachedURL!)
        XCTAssertEqual(cachedData, mockData)
    }
}
