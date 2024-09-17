import Foundation
import Webservice

public struct OpenAI {
    let apiKey: String
    let webservice: Webservice
    
    public init(apiKey: String, webservice: Webservice = Webservice()) {
        self.apiKey = apiKey
        self.webservice = webservice
    }
    
    public func createChatCompletion(model: ChatModel, messages: [ChatCompletionMessage]) async throws -> ChatCompletionResponse {
        let endpoint: Endpoint = try .chatCompletion(apiKey: apiKey, request: .init(model: model, messages: messages))
        return try await webservice.request(endpoint: endpoint)
    }
    
    public func createChatCompletionStream(model: ChatModel, messages: [ChatCompletionMessage]) throws -> AsyncThrowingStream<ChatCompletionStreamingResponse, Error> {
        let endpoint: Endpoint = try .chatCompletionStreaming(
            apiKey: apiKey, request: .init(model: model, messages: messages, stream: true)
        )
        return webservice.requestStreaming(endpoint: endpoint)
    }
}
