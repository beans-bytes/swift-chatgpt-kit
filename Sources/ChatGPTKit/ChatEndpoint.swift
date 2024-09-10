import Foundation
import Webservice

extension Endpoint where Output == ChatCompletionResponse {
    static func chatCompletion(apiKey: String, request: ChatCompletionRequest) throws -> Self {
        guard !apiKey.isEmpty else {
            throw ChatGPTKitError.invalidApiToken
        }
        
        let encoder = ChatCompletionRequest.encoder
        let data = try encoder.encode(request)
                
        return Endpoint<Output>(
            url: "https://api.openai.com/v1/chat/completions",
            method: .POST,
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data,
            timeout: 2
        )
    }
}
