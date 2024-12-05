import SwiftUI

struct RecipeListView: View {
    @ObservedObject var viewModel: RecipeListViewModel

    var body: some View {
        ZStack {
            FetchColors.maize
                .edgesIgnoringSafeArea(.all)
            VStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView("Loading...")
                case .error(let error):
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                case .content:
                    if viewModel.recipes.keys.isEmpty {
                        Text("No recipes available.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(viewModel.recipes.keys, id: \.self) { key in
                            Section {
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 15) {
                                        if let recipes = viewModel.recipes.dictionary[key] {
                                            ForEach(recipes, id: \.id) { recipe in
                                                RecipeListCell(recipe: recipe)
                                                    .task { try? await viewModel.downloadImage(for: recipe.id, key: key) }
                                            }
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets(
                                    top: 10,
                                    leading: 0,
                                    bottom: 10,
                                    trailing: 0
                                ))
                                .listRowBackground(Color.clear)
                            } header: {
                                Text(key)
                                    .foregroundColor(FetchColors.richBlack)
                                    .font(.headline)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .refreshable {
                            await viewModel.performTask()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.performTask()
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockRepo = MockFetchRepo()
    mockRepo.recipes = Recipe.list

    let viewModel = RecipeListViewModel(repo: mockRepo as Repo)

    return RecipeListView(viewModel: viewModel)
}
