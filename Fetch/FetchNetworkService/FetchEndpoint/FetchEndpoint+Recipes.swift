extension FetchEndpoint {
    static var recipes: FetchEndpoint {
        FetchEndpoint(path: "/recipes.json", method: .get)
    }

    static var malformedRecipes: FetchEndpoint {
        FetchEndpoint(path: "/recipes-malformed.json", method: .get)
    }

    static var emptyRecipes: FetchEndpoint  {
        FetchEndpoint(path: "/recipes-empty.json", method: .get)
    }
}
