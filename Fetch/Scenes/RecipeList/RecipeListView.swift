import SwiftUI

enum FetchColors {
    static var maize = Color(red: 254 / 255, green: 228 / 255, blue: 64 / 255)
    static var richBlack = Color(red: 0 / 255, green: 16 / 255, blue: 17 / 255)
    static var dodgerBlue = Color(red: 30 / 255, green: 150 / 255, blue: 252 / 255)
    static var magnolia = Color(red: 245 / 255, green: 240 / 255, blue: 246 / 255)
    static var rasberry = Color(red: 216 / 255, green: 30 / 255, blue: 91 / 255)
}

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
