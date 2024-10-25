import Foundation
import Webservice

public struct ChatCompletionRequest: Request {
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
    public let responseFormat: ResponseFormat?

    public init(
        model: ChatModel = .chatgpt4oLatest,
        messages: [ChatCompletionMessage] = [],
        temperature: Double? = nil,
        maxTokens: Int? = nil,
        n: Int? = nil,
        stop: [String]? = nil,
        stream: Bool? = nil,
        logitBias: [String: Int]? = nil,
        presencePenalty: Double? = nil,
        frequencyPenalty: Double? = nil,
        responseFormat: ResponseFormat? = nil
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
        self.responseFormat = responseFormat
    }

    enum CodingKeys: String, CodingKey {
        case model
        case messages
        case temperature
        case maxTokens = "max_tokens"
        case n
        case stop
        case stream
        case logitBias = "logit_bias"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case responseFormat = "response_format"
    }
}

public struct ChatCompletionMessage: Codable {
    public let role: ChatCompletionMessageUserRole
    public let content: String
    public let name: String?
    public let refusal: String?
    public let toolCalls: [ChatCompletionMessageToolCall]?

    public init(
        role: ChatCompletionMessageUserRole,
        content: String,
        name: String? = nil,
        refusal: String? = nil,
        toolCalls: [ChatCompletionMessageToolCall]? = nil
    ) {
        self.role = role
        self.content = content
        self.name = name
        self.refusal = refusal
        self.toolCalls = toolCalls
    }

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case refusal
        case toolCalls = "tool_calls"
    }
}

public struct ChatCompletionMessageDelta: Codable {
    public let role: ChatCompletionMessageUserRole?
    public let content: String?
    public let name: String?
    public let refusal: String?
    public let toolCalls: [ChatCompletionMessageToolCall]?

    public init(
        role: ChatCompletionMessageUserRole,
        content: String,
        name: String? = nil,
        refusal: String? = nil,
        toolCalls: [ChatCompletionMessageToolCall]? = nil
    ) {
        self.role = role
        self.content = content
        self.name = name
        self.refusal = refusal
        self.toolCalls = toolCalls
    }

    enum CodingKeys: String, CodingKey {
        case role
        case content
        case name
        case refusal
        case toolCalls = "tool_calls"
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

    public init(
        id: String,
        type: ChatCompletionMessageToolCallType,
        function: ChatCompletionMessageToolFunction
    ) {
        self.id = id
        self.type = type
        self.function = function
    }

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case function
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

    enum CodingKeys: String, CodingKey {
        case name
        case arguments
    }
}

public enum ChatModel: String, CaseIterable, Codable {
    case gpt4o_20240806 = "gpt-4o-2024-08-06"
    case chatgpt4oLatest = "chatgpt-4o-latest"
    case gpt4oMini_20240718 = "gpt-4o-mini-2024-07-18"
    case gpt4Turbo_20240409 = "gpt-4-turbo-2024-04-09"
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

    enum CodingKeys: String, CodingKey {
        case token
        case logprob
        case bytes
    }
}

public struct ChatCompletionResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
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

    public init(
        id: String,
        choices: [ChatCompletionChoice],
        created: Int,
        model: ChatModel,
        serviceTier: String?,
        systemFingerprint: String,
        object: String,
        usage: ChatCompletionUsage
    ) {
        self.id = id
        self.choices = choices
        self.created = created
        self.model = model
        self.serviceTier = serviceTier
        self.systemFingerprint = systemFingerprint
        self.object = object
        self.usage = usage
    }

    enum CodingKeys: String, CodingKey {
        case id
        case choices
        case created
        case model
        case serviceTier = "service_tier"
        case systemFingerprint = "system_fingerprint"
        case object
        case usage
    }
}

public struct ChatCompletionChoice: Codable {
    public let finishReason: String
    public let index: Int
    public let message: ChatCompletionMessage
    public let logprobs: [ChatCompletionTokenLogprob]?

    public init(
        finishReason: String,
        index: Int,
        message: ChatCompletionMessage,
        logprobs: [ChatCompletionTokenLogprob]?
    ) {
        self.finishReason = finishReason
        self.index = index
        self.message = message
        self.logprobs = logprobs
    }

    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index
        case message
        case logprobs
    }
}

public struct ChatCompletionStreamingResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
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

    public init(
        id: String,
        choices: [ChatCompletionStreamingChoice],
        created: Int,
        model: ChatModel,
        serviceTier: String?,
        systemFingerprint: String,
        object: String,
        usage: ChatCompletionUsage?
    ) {
        self.id = id
        self.choices = choices
        self.created = created
        self.model = model
        self.serviceTier = serviceTier
        self.systemFingerprint = systemFingerprint
        self.object = object
        self.usage = usage
    }

    enum CodingKeys: String, CodingKey {
        case id
        case choices
        case created
        case model
        case serviceTier = "service_tier"
        case systemFingerprint = "system_fingerprint"
        case object
        case usage
    }
}

public struct ChatCompletionStreamingChoice: Codable {
    public let finishReason: String?
    public let index: Int
    public let delta: ChatCompletionMessageDelta
    public let logprobs: [ChatCompletionTokenLogprob]?

    public init(
        finishReason: String?,
        index: Int,
        delta: ChatCompletionMessageDelta,
        logprobs: [ChatCompletionTokenLogprob]?
    ) {
        self.finishReason = finishReason
        self.index = index
        self.delta = delta
        self.logprobs = logprobs
    }

    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index
        case delta
        case logprobs
    }
}

public struct ChatCompletionUsage: Codable {
    public let promptTokens: Int
    public let completionTokens: Int
    public let totalTokens: Int

    public init(
        promptTokens: Int,
        completionTokens: Int,
        totalTokens: Int
    ) {
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.totalTokens = totalTokens
    }

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

public struct TranscriptionResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    public let task: String?
    public let language: String?
    public let duration: Double?
    public let text: String
    public let words: [Word]?

    enum CodingKeys: String, CodingKey {
        case task
        case language
        case duration
        case text
        case words
    }
}

public struct Word: Codable {
    public let word: String
    public let start: Double
    public let end: Double

    enum CodingKeys: String, CodingKey {
        case word
        case start
        case end
    }
}

public struct SpeechRequest: Request {
    public init(
        model: SpeechModel,
        input: String,
        voice: Voice,
        responseFormat: AudioFormat?,
        speed: Double?
    ) {
        self.model = model
        self.input = input
        self.voice = voice
        self.responseFormat = responseFormat
        self.speed = speed
    }

    public let model: SpeechModel
    public let input: String
    public let voice: Voice
    public let responseFormat: AudioFormat?
    public let speed: Double?

    enum CodingKeys: String, CodingKey {
        case model
        case input
        case voice
        case responseFormat = "response_format"
        case speed
    }
}

public enum SpeechModel: String, CaseIterable, Hashable, Encodable {
    case tts1 = "tts-1"
    case tts1HD = "tts-1-hd"
}

public enum Voice: String, CaseIterable, Hashable, Encodable {
    case alloy, echo, fable, onyx, nova, shimmer
}

public enum AudioFormat: String, Encodable {
    case mp3, opus, aac, flac, wav, pcm
}

public struct SpeechResponse: Response, Codable {
    public static let decoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}
