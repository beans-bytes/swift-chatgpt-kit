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
        
        // Set headers
        for (field, value) in headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        // Set body
        request.httpBody = body
        
        return request
    }
}

func createMultipartFormData(
    parameters: [String: String],
    fileData: Data,
    fileName: String,
    mimeType: String,
    boundary: String
) -> Data {
    var body = Data()
    
    // Add parameters
    for (key, value) in parameters {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }
    
    // Add file data
    body.append("--\(boundary)\r\n")
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
    body.append("Content-Type: \(mimeType)\r\n\r\n")
    body.append(fileData)
    body.append("\r\n")
    
    body.append("--\(boundary)--\r\n")
    return body
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
