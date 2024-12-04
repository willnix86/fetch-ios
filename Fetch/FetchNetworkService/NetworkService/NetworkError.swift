enum NetworkError: Error {
    case invalidURL
    case invalidStatusCode
    case decodeError
    case noData

    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .decodeError:
            return "An error occurred attempting to decode the object."
        case .invalidStatusCode:
            return "Something went wrong!"
        case .noData:
            return "No results found."
        }
    }
}
