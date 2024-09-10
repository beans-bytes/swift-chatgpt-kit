import Foundation
import AsyncHTTPClient
import NIOHTTP1

public struct Endpoint<Output: Response> {
    let url: String
    let method: HTTPMethod
    let headers: [String: String]?
    let timeout: Int
    
    public init(url: String, method: HTTPMethod, headers: [String : String]?, timeout: Int = 15) {
        self.url = url
        self.method = method
        self.headers = headers
        self.timeout = timeout
    }
}

extension Endpoint {
    func asRequest() throws -> HTTPClientRequest {
        var request = HTTPClientRequest(url: url)
        request.method = method
        headers?.forEach { name, value in
            request.headers.add(name: name, value: value)
        }
        return request
    }
}
