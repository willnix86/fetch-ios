final class FetchRepo: Repo {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getRecipes() async throws -> [Recipe] {
        try await networkService.sendRequest(endpoint: FetchEndpoint.recipes)
    }
}
