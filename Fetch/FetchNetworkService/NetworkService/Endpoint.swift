protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
}

extension Endpoint {
    var scheme: String { "https" }
    var host: String { "d3jbb8n5wk0qxi.cloudfront.net" }
}

enum RequestMethod: String {
    case get = "GET"
}
