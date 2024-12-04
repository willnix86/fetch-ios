import SwiftUI

@main
struct FetchApp: App {
    let repo = FetchRepo(networkService: FetchNetworkService())

    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel(repo: repo))
        }
    }
}
