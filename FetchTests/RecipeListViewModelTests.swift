import XCTest
@testable import Fetch

final class RecipeListViewModelTests: XCTestCase {
    var viewModel: RecipeListViewModel!
    var mockRepo: MockFetchRepo!

    override func setUp() {
        super.setUp()
        mockRepo = MockFetchRepo()
        viewModel = RecipeListViewModel(repo: mockRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockRepo = nil
        super.tearDown()
    }

    func test_initialState() {
        XCTAssertEqual(viewModel.viewState, .loading)
        XCTAssertTrue(viewModel.cuisines.isEmpty)
        XCTAssertTrue(viewModel.recipesDictionary.isEmpty)
    }

    func test_performTask_ouputsContentViewState() async {
        mockRepo.recipes = Recipe.list

        await viewModel.performTask()

        XCTAssertEqual(viewModel.viewState, .content)
    }

    func test_performTask_ouputsCuisines() async {
        mockRepo.recipes = Recipe.list

        await viewModel.performTask()

        XCTAssertEqual(viewModel.cuisines, [Recipe.stub.cuisine])
    }

    func test_performTask_ouputsRecipes() async {
        mockRepo.recipes = Recipe.list

        await viewModel.performTask()

        XCTAssertEqual(
            viewModel.recipesDictionary[Recipe.stub.cuisine]?.count,
            6
        )
    }

    func test_performTask_outputsError() async {
        mockRepo.error = NetworkError.decodeError

        await viewModel.performTask()

        XCTAssertEqual(
            viewModel.viewState,
            .error(NetworkError.decodeError.message)
        )
    }

    func test_performTask_outputsEmptyData() async {
        mockRepo.error = NetworkError.decodeError

        await viewModel.performTask()

        XCTAssertTrue(viewModel.cuisines.isEmpty)
        XCTAssertTrue(viewModel.recipesDictionary.isEmpty)
    }

    func test_downloadImage_addsURLToRecipesDictionary() async {
        mockRepo.recipes = Recipe.list
        mockRepo.imageURL = URL(string: "https://example.com/image.jpg")

        await viewModel.performTask()

        try? await viewModel.downloadImage(
            for: Recipe.stub.id,
            cuisine: Recipe.stub.cuisine
        )

        XCTAssertEqual(
            viewModel.recipesDictionary[Recipe.stub.cuisine]?.first?.largePhotoDataURL,
            mockRepo.imageURL
        )
    }

    func test_downloadImage_urlIsNilIfError() async {
        mockRepo.recipes = Recipe.list

        await viewModel.performTask()

        mockRepo.error = NetworkError.decodeError

        try? await viewModel.downloadImage(
            for: Recipe.stub.id,
            cuisine: Recipe.stub.cuisine
        )

        XCTAssertNil(
            viewModel.recipesDictionary[Recipe.stub.cuisine]?.first?.largePhotoDataURL
        )
    }
}
