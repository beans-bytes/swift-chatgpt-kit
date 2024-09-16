import Foundation
import Webservice

public struct ChatCompletionRequest: Request, Codable {
    public static let encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    public let model: ChatModel
    public let messages: [ChatCompletionMessage]
    public let temperature: Double?
    public let maxTokens: Int?
    public let n: Int?
    public let stop: [String]?
    public let stream: Bool?
    public let logitBias: [String: Int]?
    public let presencePenalty: Double?
    public let frequencyPenalty: Double?
    
    init(
        model: ChatModel = .chatgpt4oLatest,
        messages: [ChatCompletionMessage] = [],
        temperature: Double? = 1,
        maxTokens: Int? = 512,
        n: Int? = 1,
        stop: [String]? = nil,
        stream: Bool? = false,
        logitBias: [String : Int]? = nil,
        presencePenalty: Double? = 0,
        frequencyPenalty: Double? = 0
    ) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.n = n
        self.stop = stop
        self.stream = stream
        self.logitBias = logitBias
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
    }
}

public struct ChatCompletionMessage: Codable {
    public let role: ChatCompletionMessageUserRole
    public let content: String
    public let name: String?
    public let refusal: String?
    public let toolCalls: [ChatCompletionMessageToolCall]?
}

public enum ChatCompletionMessageUserRole: String, Codable {
    case user
    case system
    case assistant
    case tool
}

public struct ChatCompletionMessageToolCall: Codable {
    public let id: String
    public let type: ChatCompletionMessageToolCallType
    public let function: ChatCompletionMessageToolFunction
}

public enum ChatCompletionMessageToolCallType: String, Codable {
    case function
}

public struct ChatCompletionMessageToolFunction: Codable {
    public let name: String
    public let arguments: String // JSON Format
}

public enum ChatModel: String, CaseIterable, Codable {
    case gpt4o = "gpt-4o"
    case gpt4o_20240513 = "gpt-4o-2024-05-13"
    case gpt4o_20240806 = "gpt-4o-2024-08-06"
    case chatgpt4oLatest = "chatgpt-4o-latest"
    case gpt4oMini = "gpt-4o-mini"
    case gpt4Turbo = "gpt-4-turbo"
}

public struct ChatCompletionTokenLogprob: Codable {
    public let token: String
    public let logprob: Double
    public let bytes: [Int]?
}

public struct ChatCompletionResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public let id: String
    public let choices: [ChatCompletionChoice]
    public let created: Int
    public let model: ChatModel
    public let serviceTier: String?
    public let systemFingerprint: String
    public let object: String
    public let usage: ChatCompletionUsage
}

public struct ChatCompletionChoice: Codable {
    public let finishReason: String
    public let index: Int
    public let message: ChatCompletionMessage
    public let logprobs: [ChatCompletionTokenLogprob]?
}

public struct ChatCompletionUsage: Codable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
}
