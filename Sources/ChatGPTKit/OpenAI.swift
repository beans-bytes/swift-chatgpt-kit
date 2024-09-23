import Foundation
import Webservice

public struct OpenAI {
    let apiKey: String
    let baseUrl: String
    let webservice: Webservice
    
    public init(apiKey: String, baseUrl: String = "https://api.openai.com/v1/chat/", webservice: Webservice = Webservice()) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.webservice = webservice
    }
    
    public func createChatCompletion(model: ChatModel, messages: [ChatCompletionMessage]) async throws -> ChatCompletionResponse {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("completion")
        let completionRequest = ChatCompletionRequest(model: model, messages: messages, stream: false)
        let encoder = ChatCompletionRequest.encoder
        let data = try encoder.encode(completionRequest)
                
        let endpoint = Endpoint<ChatCompletionResponse>(
            url: url,
            method: .POST,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data,
            timeout: 2
        )
        
        return try await webservice.request(endpoint: endpoint)
    }
    
    public func createChatCompletionStream(model: ChatModel, messages: [ChatCompletionMessage]) throws -> AsyncThrowingStream<ChatCompletionStreamingResponse, Error> {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("completion")
        let completionStreamingRequest = ChatCompletionRequest(model: model, messages: messages, stream: true)
        let encoder = ChatCompletionRequest.encoder
        let data = try encoder.encode(completionStreamingRequest)
        
        let endpoint = Endpoint<ChatCompletionStreamingResponse>(
            url: url,
            method: .POST,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data,
            timeout: 2
        )
        
        return webservice.requestStreaming(endpoint: endpoint)
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
}
