import Foundation

struct Recipe: Identifiable {
    var id: String
    let cuisine: String
    let name: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
}

extension Recipe {
    init(from response: RecipeDto) {
        self.cuisine = response.cuisine
        self.name = response.name
        self.id = response.uuid

        if let photoURLLarge = response.photoURLLarge {
            self.photoURLLarge = URL(string: photoURLLarge)
        } else {
            self.photoURLLarge = nil
        }

        if let photoURLSmall = response.photoURLSmall {
            self.photoURLSmall = URL(string:photoURLSmall)
        } else {
            self.photoURLSmall = nil
        }

        if let sourceURL = response.sourceURL {
            self.sourceURL = URL(string: sourceURL)
        } else {
            self.sourceURL = nil
        }

        if let youtubeURL = response.youtubeURL {
            self.youtubeURL = URL(string: youtubeURL)
        } else {
            self.youtubeURL = nil
        }
    }
}
