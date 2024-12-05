import Foundation
import SwiftUI

typealias RecipeListVM = RecipeListViewModelInputs & RecipeListViewModelOutputs

protocol RecipeListViewModelInputs {
    func performTask() async
}

protocol RecipeListViewModelOutputs {
    var viewState: ViewState { get }
    var cuisines: [String] { get }
    var recipesDictionary: [String: [Recipe]] { get }
}

final class RecipeListViewModel: ObservableObject, RecipeListVM {
    @Published var viewState: ViewState = .loading
    @Published var cuisines: [String] = []
    @Published var recipesDictionary: [String: [Recipe]] = [:]

    private let repo: Repo

    init(repo: Repo) {
        self.repo = repo
    }

    func performTask() async {
        await MainActor.run { viewState = .loading }

        do {
            let fetchedRecipes = try await repo.getRecipes()
            await createDictionary(from: fetchedRecipes)
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

    func downloadImage(for recipeId: String, cuisine: String) async throws {
        guard let recipeIndex = recipesDictionary[cuisine]?.firstIndex(where: { $0.id == recipeId }),
              let photoURLLarge = recipesDictionary[cuisine]?[recipeIndex].photoURLLarge else { return }

        do {
            let dataURL = try await repo.fetchRecipeImage(from: photoURLLarge)

            await MainActor.run {
                recipesDictionary[cuisine]?[recipeIndex].largePhotoDataURL = dataURL
            }
        } catch {
            print("Error downloading image: \(error)")
        }
    }

    private func createDictionary(from recipes: [Recipe]) async {
        let recipeDict = recipes.reduce(into: [String: [Recipe]]()) { result, recipe in
            result[recipe.cuisine, default: []].append(recipe)
        }

        let cuisines = recipeDict.keys.sorted()

        await MainActor.run {
            self.cuisines = cuisines
            self.recipesDictionary = recipeDict
            self.viewState = .content
        }
    }
}
