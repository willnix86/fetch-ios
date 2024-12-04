import SwiftUI

struct RecipeListCell: View {
    var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                if let imageURL = recipe.photoURLLarge {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 165, height: 225)
                        } else if phase.error != nil {
                            fallbackImage
                        } else {
                            ProgressView()
                                .frame(width: 165, height: 225)
                        }
                    }
                    .cornerRadius(8)
                    .padding(EdgeInsets(
                        top: 5,
                        leading: 0,
                        bottom: 0,
                        trailing: 0
                    ))
                } else {
                    fallbackImage
                }

                HStack {
                    if let sourceURL = recipe.sourceURL {
                        Button(action: {
                            openURL(sourceURL)
                        }) {
                            Image(systemName: "link")
                                .foregroundColor(FetchColors.rasberry)
                                .padding(8)
                                .background(FetchColors.magnolia)
                                .clipShape(Circle())
                        }
                        .padding(.top, 8)
                        .padding(.leading, 4)
                    }

                    Spacer()

                    if let youtubeURL = recipe.youtubeURL {
                        Button(action: {
                            openURL(youtubeURL)
                        }) {
                            Image(systemName: "play.rectangle.fill")
                                .foregroundColor(FetchColors.dodgerBlue)
                                .padding(8)
                                .background(FetchColors.magnolia)
                                .clipShape(Circle())
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 4)
                    }
                }
                .frame(width: 165)
            }

            Text(recipe.name)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 150, alignment: .leading)

            Spacer()
        }
    }

    private var fallbackImage: some View {
        ZStack {
            Color.gray.opacity(0.2)
            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(.secondary)
                .frame(height: 225)
        }
        .frame(width: 165, height: 225)
    }

    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    RecipeListCell(recipe: Recipe.stub)
}
