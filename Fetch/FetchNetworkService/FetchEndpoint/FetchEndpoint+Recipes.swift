extension FetchEndpoint {
    static var recipes: FetchEndpoint {
        FetchEndpoint(path: "/recipes.json", method: .get)
    }
}
