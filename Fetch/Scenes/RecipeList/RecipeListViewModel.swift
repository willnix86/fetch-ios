import Foundation
import SwiftUI

typealias RecipeOutput = (keys: [String], dictionary: [String: [Recipe]])
typealias RecipeListVM = RecipeListViewModelInputs & RecipeListViewModelOutputs

protocol RecipeListViewModelInputs {
    func performTask() async
}

protocol RecipeListViewModelOutputs {
    var viewState: ViewState { get }
    var recipes: RecipeOutput { get }
}

final class RecipeListViewModel: ObservableObject, RecipeListVM {

    @Published var viewState: ViewState = .loading
    @Published var recipes: RecipeOutput = ([], [:])

    private let repo: Repo

    init(repo: Repo) {
        self.repo = repo
    }

    func performTask() async {
        await MainActor.run { viewState = .loading }

        do {
            let fetchedRecipes = try await repo.getRecipes()
            createDictionary(from: fetchedRecipes)
        } catch {
            let errorMessage: String
            if let fetchError = error as? NetworkError {
                errorMessage = fetchError.message
            } else {
                errorMessage = error.localizedDescription
            }

            await MainActor.run {
                self.viewState = .error(errorMessage)
            }
            print("API error: \(error)")
        }
    }

    private func createDictionary(from recipes: [Recipe]) {
        var recipeKeys: Set<String> = Set()
        var recipeDict: [String: [Recipe]] = [:]

        recipes.forEach { recipe in
            recipeKeys.insert(recipe.cuisine)

            if recipeDict[recipe.cuisine] == nil {
                let newRecipeArray: [Recipe] = [recipe]
                recipeDict[recipe.cuisine] = newRecipeArray
            } else {
                recipeDict[recipe.cuisine]?.append(recipe)
            }
        }

        let sortedKeys = recipeKeys.sorted(by: < )

        self.recipes = (sortedKeys, recipeDict)
        self.viewState = .content
    }
}
