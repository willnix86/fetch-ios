import Foundation

extension Recipe {
    static var stub = Recipe(
        id: "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
        cuisine: "British",
        name: "Bakewell Tart",
        photoURLLarge: URL(string: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F6716666.jpg&q=60&c=sc&poi=auto&orient=true&h=512"),
        photoURLSmall: URL(string:"https://www.allrecipes.com/thmb/6OUTR0v5VWPtFHDI0QQldVbRAhU=/282x188/filters:no_upscale():max_bytes(150000):strip_icc()/6716666-b24f097491a1401aaec9700d67c45184.jpg"),
        sourceURL: URL(string: "https://some.url/index.html"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=some.id")
    )

    static var list: [Recipe] {
        [stub, stub, stub, stub, stub, stub]
    }
}
