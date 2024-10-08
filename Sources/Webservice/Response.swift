import Foundation

public protocol Response: Decodable {
    static var decoder: JSONDecoder { get }
}

public protocol Request: Encodable {

}
