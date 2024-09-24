import Foundation

public struct MultipartFormData {
    private let boundary: String
    private var body = Data()

    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }

    public var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }

    public mutating func addParameter(name: String, value: String) {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }

    public mutating func addParameters(name: String, values: [String]) {
        for value in values {
            addParameter(name: name, value: value)
        }
    }

    public mutating func addFile(
        data: Data,
        name: String,
        fileName: String,
        mimeType: String
    ) {
        var field = "--\(boundary)\r\n"
        field += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
        field += "Content-Type: \(mimeType)\r\n\r\n"
        body.append(field)
        body.append(data)
        body.append("\r\n")
    }

    public func finalize() -> Data {
        var finalData = body
        finalData.append("--\(boundary)--\r\n")
        return finalData
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
