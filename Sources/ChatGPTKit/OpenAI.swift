import Foundation
import Webservice

public struct OpenAI {
    let apiKey: String
    let baseUrl: String
    let webservice: Webservice
    
    public init(apiKey: String, baseUrl: String = "https://api.openai.com/v1/", webservice: Webservice = Webservice()) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.webservice = webservice
    }
    
    public func createChatCompletion(model: ChatModel, messages: [ChatCompletionMessage]) async throws -> ChatCompletionResponse {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("chat/completions")
        let completionRequest = ChatCompletionRequest(model: model, messages: messages, stream: false)
        let encoder = ChatCompletionRequest.encoder
        let data = try encoder.encode(completionRequest)
                
        let endpoint = Endpoint<ChatCompletionResponse>(
            url: url,
            timeout: 2, 
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data
        )
        
        return try await webservice.request(endpoint: endpoint)
    }
    
    public func createChatCompletionStream(model: ChatModel, messages: [ChatCompletionMessage]) throws -> AsyncThrowingStream<ChatCompletionStreamingResponse, Error> {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("chat/completions")
        let completionStreamingRequest = ChatCompletionRequest(model: model, messages: messages, stream: true)
        let encoder = ChatCompletionRequest.encoder
        let data = try encoder.encode(completionStreamingRequest)
        
        let endpoint = Endpoint<ChatCompletionStreamingResponse>(
            url: url,
            timeout: 2, 
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data
        )
        
        return webservice.requestStreaming(endpoint: endpoint)
    }
    
    public func createAudioTranscription(fileUrl: URL) async throws -> TranscriptionResponse {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("audio/transcriptions")
        
        let fileData = try Data(contentsOf: fileUrl)
        
        let parameters: [String: Any] = [
            "timestamp_granularities[]": ["word"],
            "model": "whisper-1",
            "response_format": "verbose_json"
        ]

        let boundary = "Boundary-\(UUID().uuidString)"
        
        let endpoint = Endpoint<TranscriptionResponse>(
            url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!,
            timeout: 60,
            method: "POST",
            headers: [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: createMultipartFormData(
                parameters: parameters,
                fileData: fileData,
                fileFieldName: "file",
                fileName: "audio.m4a",
                mimeType: "audio/m4a",
                boundary: boundary
            )
        )
        return try await webservice.request(endpoint: endpoint)
    }
    
    private func validateAPIKey(apiKey: String) throws {
        guard !apiKey.isEmpty else {
            throw ChatGPTKitError.invalidApiToken
        }
    }
    
    private func validateBaseUrl(baseURL: String) throws -> URL {
        guard let url = URL(string: baseUrl) else {
            throw ChatGPTKitError.invalidBaseURL
        }
        return url
    }
    
    private func createMultipartFormData(
        parameters: [String: Any],
        fileData: Data,
        fileFieldName: String,
        fileName: String,
        mimeType: String,
        boundary: String
    ) -> Data {
        var body = Data()
        
        // Add parameters
        for (key, value) in parameters {
            if let array = value as? [Any] {
                for element in array {
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append("\(element)\r\n")
                }
            } else {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        // Add file data
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(fileFieldName)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")
        
        // Close boundary
        body.append("--\(boundary)--\r\n")
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
