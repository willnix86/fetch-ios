enum NetworkError: Error {
    case noResponse
    case failedToCreateRequest
    case invalidStatusCode
    case decodeError
    case noData

    var message: String {
        switch self {
        case .noResponse:
            return "No response from the server."
        case .failedToCreateRequest:
            return "Failed to create a request."
        case .decodeError:
            return "An error occurred attempting to decode the object."
        case .invalidStatusCode:
            return "Something went wrong!"
        case .noData:
            return "No results found."
        }
    }
}
