import Foundation
import Webservice

public struct OpenAI {
    let apiKey: String
    let webservice: Webservice
    
    init(apiKey: String, webservice: Webservice = Webservice()) {
        self.apiKey = apiKey
        self.webservice = webservice
    }
    
    public func createChatCompletion(model: ChatModel, messages: [ChatCompletionMessage]) async throws -> ChatCompletionResponse {
        let endpoint: Endpoint = try .chatCompletion(apiKey: apiKey, request: .init(model: model, messages: messages))
        return try await webservice.request(endpoint: endpoint)
    }
}
