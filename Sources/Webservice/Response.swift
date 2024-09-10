import Foundation

public protocol Response: Codable {
    static var decoder: JSONDecoder { get }
}
