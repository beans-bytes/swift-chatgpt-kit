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
    
    public init(
        model: ChatModel = .chatgpt4oLatest,
        messages: [ChatCompletionMessage] = [],
        temperature: Double? = nil,
        maxTokens: Int? = nil,
        n: Int? = nil,
        stop: [String]? = nil,
        stream: Bool? = nil,
        logitBias: [String : Int]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil
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
    
    public init(role: ChatCompletionMessageUserRole, content: String, name: String? = nil, refusal: String? = nil, toolCalls: [ChatCompletionMessageToolCall]? = nil) {
        self.role = role
        self.content = content
        self.name = name
        self.refusal = refusal
        self.toolCalls = toolCalls
    }
}

public struct ChatCompletionMessageDelta: Codable {
    public let role: ChatCompletionMessageUserRole?
    public let content: String?
    public let name: String?
    public let refusal: String?
    public let toolCalls: [ChatCompletionMessageToolCall]?
    
    public init(role: ChatCompletionMessageUserRole, content: String, name: String? = nil, refusal: String? = nil, toolCalls: [ChatCompletionMessageToolCall]? = nil) {
        self.role = role
        self.content = content
        self.name = name
        self.refusal = refusal
        self.toolCalls = toolCalls
    }
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
    
    public init(id: String, type: ChatCompletionMessageToolCallType, function: ChatCompletionMessageToolFunction) {
        self.id = id
        self.type = type
        self.function = function
    }
}

public enum ChatCompletionMessageToolCallType: String, Codable {
    case function
}

public struct ChatCompletionMessageToolFunction: Codable {
    public let name: String
    public let arguments: String // JSON Format
    
    public init(name: String, arguments: String) {
        self.name = name
        self.arguments = arguments
    }
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
    
    public init(token: String, logprob: Double, bytes: [Int]?) {
        self.token = token
        self.logprob = logprob
        self.bytes = bytes
    }
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
    
    public init(id: String, choices: [ChatCompletionChoice], created: Int, model: ChatModel, serviceTier: String?, systemFingerprint: String, object: String, usage: ChatCompletionUsage) {
        self.id = id
        self.choices = choices
        self.created = created
        self.model = model
        self.serviceTier = serviceTier
        self.systemFingerprint = systemFingerprint
        self.object = object
        self.usage = usage
    }
}

public struct ChatCompletionChoice: Codable {
    public let finishReason: String
    public let index: Int
    public let message: ChatCompletionMessage
    public let logprobs: [ChatCompletionTokenLogprob]?
    
    public init(finishReason: String, index: Int, message: ChatCompletionMessage, logprobs: [ChatCompletionTokenLogprob]?) {
        self.finishReason = finishReason
        self.index = index
        self.message = message
        self.logprobs = logprobs
    }
}

public struct ChatCompletionStreamingResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public let id: String
    public let choices: [ChatCompletionStreamingChoice]
    public let created: Int
    public let model: ChatModel
    public let serviceTier: String?
    public let systemFingerprint: String
    public let object: String
    public let usage: ChatCompletionUsage?
    
    public init(id: String, choices: [ChatCompletionStreamingChoice], created: Int, model: ChatModel, serviceTier: String?, systemFingerprint: String, object: String, usage: ChatCompletionUsage) {
        self.id = id
        self.choices = choices
        self.created = created
        self.model = model
        self.serviceTier = serviceTier
        self.systemFingerprint = systemFingerprint
        self.object = object
        self.usage = usage
    }
}

public struct ChatCompletionStreamingChoice: Codable {
    public let finishReason: String?
    public let index: Int
    public let delta: ChatCompletionMessageDelta
    public let logprobs: [ChatCompletionTokenLogprob]?
    
    public init(finishReason: String?, index: Int, delta: ChatCompletionMessageDelta, logprobs: [ChatCompletionTokenLogprob]?) {
        self.finishReason = finishReason
        self.index = index
        self.delta = delta
        self.logprobs = logprobs
    }
}

public struct ChatCompletionUsage: Codable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int
    
    public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }
}

public struct TranscriptionResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public let task: String?
    public let language: String?
    public let duration: Double?
    public let text: String
    public let words: [Word]?
}

public struct Word: Codable {
    public let word: String
    public let start: Double
    public let end: Double
}

