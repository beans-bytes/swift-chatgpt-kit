import Foundation

public enum WebserviceError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
}
