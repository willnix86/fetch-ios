import Foundation

final class FetchRepo: Repo {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getRecipes() async throws -> [Recipe] {
        let response: RecipeListDto = try await networkService.sendRequest(
            endpoint: FetchEndpoint.recipes
        )
        return response.recipes.map(Recipe.init(from:))
    }

    func fetchRecipeImage(from url: URL) async throws -> URL? {
        return try await networkService.fetchData(from: url)
    }
}
