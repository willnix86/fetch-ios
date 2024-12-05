import Foundation

protocol Repo {
    func getRecipes() async throws -> [Recipe]
    func fetchRecipeImage(from url: URL) async throws -> URL?
}
