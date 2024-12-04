protocol Repo {
    func getRecipes() async throws -> [Recipe]
}
