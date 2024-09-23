import Foundation
import AsyncHTTPClient
import NIOHTTP1

public struct Endpoint<Output: Response> {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]?
    let timeout: Int
    let body: Data?
    
    public init(url: URL, method: HTTPMethod, headers: [String : String]? = nil, body: Data? = nil, timeout: Int = 15) {
        self.url = url
        self.method = method
        self.headers = headers
        self.timeout = timeout
        self.body = body
    }
}

extension Endpoint {
    func asRequest() throws -> HTTPClientRequest {
        var request = HTTPClientRequest(url: url.absoluteString)
        request.method = method
        headers?.forEach { name, value in
            request.headers.add(name: name, value: value)
        }
        if let body {
            request.body = .bytes(.init(data: body))
        }
        return request
    }
}
