protocol Repo {
    func getRecipes() async throws -> [Recipe]
}

struct Recipe: Decodable {
    
}
