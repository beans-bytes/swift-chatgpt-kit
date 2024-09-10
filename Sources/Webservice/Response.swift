import Foundation

public protocol Response: Codable {
    static var decoder: JSONDecoder { get }
}

public protocol Request: Codable {
    static var encoder: JSONEncoder { get }
}
