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
    private let session: URLSession
    private let cache: URLCache

    init(repo: Repo) {
        self.repo = repo
        self.cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            directory: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        )

        let configuration = URLSessionConfiguration.default
        configuration.urlCache = self.cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad

        self.session = URLSession(configuration: configuration)
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

    func downloadImage(for recipeId: String, key: String) async throws {
        guard let recipeIndex = recipes.dictionary[key]?.firstIndex(where: { $0.id == recipeId }),
              let photoURLLarge = recipes.dictionary[key]?[recipeIndex].photoURLLarge else { return }

        let request = URLRequest(url: photoURLLarge)

        if let cachedResponse = cache.cachedResponse(for: request),
           let cachedImageURL = saveToDisk(data: cachedResponse.data) {
            await MainActor.run {
                recipes.dictionary[key]?[recipeIndex].largePhotoDataURL = cachedImageURL
            }
            return
        }

        let (data, response) = try await session.data(for: request)

        if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
        }

        if let dataURL = saveToDisk(data: data) {
            await MainActor.run {
                recipes.dictionary[key]?[recipeIndex].largePhotoDataURL = dataURL
            }
        }
    }

    private func saveToDisk(data: Data) -> URL? {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString + ".png"
        guard let fileURL = cacheDirectory?.appendingPathComponent(fileName) else { return nil }

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save image to disk: \(error)")
            return nil
        }
    }

    private func createDictionary(from recipes: [Recipe]) async {
        let recipeDict = recipes.reduce(into: [String: [Recipe]]()) { result, recipe in
            result[recipe.cuisine, default: []].append(recipe)
        }

        let recipeKeys = recipeDict.keys.sorted()

        await MainActor.run {
            self.recipes = (recipeKeys, recipeDict)
            self.viewState = .content
        }
    }
}
