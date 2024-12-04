final class FetchEndpoint: Endpoint {
    var path: String
    var method: RequestMethod

    init(path: String, method: RequestMethod) {
        self.path = path
        self.method = method
    }
}
