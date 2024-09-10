import Foundation
import Webservice

struct ChatCompletionRequestMessage: Codable {
    let role: String
    let content: String
}

enum ChatModel: String, Codable {
    case gpt4o = "gpt-4o"
    case gpt4o_20240513 = "gpt-4o-2024-05-13"
    case gpt4o_20240806 = "gpt-4o-2024-08-06"
    case chatgpt4oLatest = "chatgpt-4o-latest"
    case gpt4oMini = "gpt-4o-mini"
    case gpt4Turbo = "gpt-4-turbo"
}

struct CreateChatCompletionRequest: Codable {
    let model: ChatModel
    let messages: [ChatCompletionRequestMessage]
    let temperature: Double?
    let maxTokens: Int?
    let n: Int?
    let stop: [String]?
    let stream: Bool?
    let logitBias: [String: Int]?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
}

struct ChatCompletionTokenLogprob: Codable {
    let token: String
    let logprob: Double
    let bytes: [Int]?
}

struct ChatCompletionChoice: Codable {
    let finishReason: String
    let index: Int
    let message: ChatCompletionRequestMessage
    let logprobs: [ChatCompletionTokenLogprob]?
}

struct CreateChatCompletionResponse: Response, Codable {
    static let decoder = JSONDecoder()
    
    let id: String
    let choices: [ChatCompletionChoice]
    let created: Int
    let model: String
    let object: String
}
