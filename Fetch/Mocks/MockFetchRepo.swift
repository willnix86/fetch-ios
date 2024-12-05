import Foundation

final class MockFetchRepo: Repo {
    var error: Error?
    var recipes: [Recipe]?
    var imageURL: URL?

    func getRecipes() async throws -> [Recipe] {
        if let error {
            throw error
        } else {
            return recipes ?? []
        }
    }

    func fetchRecipeImage(from url: URL) async throws -> URL? {
        if let error {
            throw error
        } else {
            return imageURL
        }
    }
}
