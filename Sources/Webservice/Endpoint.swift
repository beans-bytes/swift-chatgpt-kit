import Foundation

public struct Endpoint<Output: Response> {
    let url: URL
    let timeout: TimeInterval
    let method: String
    let headers: [String: String]
    let body: Data?
    
    public init(url: URL, timeout: TimeInterval, method: String, headers: [String : String], body: Data?) {
        self.url = url
        self.timeout = timeout
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.httpMethod = method
        
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        request.httpBody = body
        
        return request
    }
}
