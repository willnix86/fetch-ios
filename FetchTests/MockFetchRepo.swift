@testable import Fetch

final class MockFetchRepo: Repo {
    var error: Error?
    var recipes: [Recipe]?

    func getRecipes() async throws -> [Recipe] {
        if let error {
            throw error
        } else {
            return recipes ?? []
        }
    }
}
