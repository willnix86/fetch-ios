import SwiftUI

@main
struct FetchApp: App {
    let repo = FetchRepo(
        networkService: FetchNetworkService(
            session: URLSession(configuration: .default),
            cacheDirectory: FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask
            ).first
        )
    )

    var body: some Scene {
        WindowGroup {
            RecipeListView(
                viewModel: RecipeListViewModel(repo: repo)
            )
        }
    }
}
