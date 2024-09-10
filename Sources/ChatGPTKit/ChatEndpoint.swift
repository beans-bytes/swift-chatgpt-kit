import Foundation
import Webservice

extension Endpoint where Output == CreateChatCompletionResponse {
    static func chatCompletion() -> Self {
        Endpoint<Output>(
            url: "https://api.openai.com/v1/chat/completions",
            method: .POST,
            headers: ["Content-Type": "application/json"],
            timeout: 2
        )
    }
}
