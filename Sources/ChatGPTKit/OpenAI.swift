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
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey)"
            ],
            body: data
        )
        
        return webservice.requestStreaming(endpoint: endpoint)
    }
    
    ///
    /// - Parameters:
    ///  -  language: Language Code per ISO 639 Defintition s, [Wikipedia](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes)
    public func createAudioTranscription(fileUrl: URL, language iso639: String?) async throws -> TranscriptionResponse {
        try validateAPIKey(apiKey: apiKey)
        
        var url = try validateBaseUrl(baseURL: baseUrl)
        url.appendPathComponent("audio/transcriptions")
        
        let fileData = try Data(contentsOf: fileUrl)
        
        var formData = MultipartFormData()
        formData.addParameters(name: "timestamp_granularities[]", values: ["word"])
        formData.addParameter(name: "model", value: "whisper-1")
        formData.addParameter(name: "response_format", value: "verbose_json")
        if let iso639 {
            formData.addParameter(name: "language", value: iso639)
        }
        formData.addFile(
            data: fileData,
            name: "file",
            fileName: "audio.m4a",
            mimeType: "audio/mp4"
        )
        
        let endpoint = Endpoint<TranscriptionResponse>(
            url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!,
            method: "POST",
            headers: [
                "Content-Type": formData.contentType,
                "Authorization": "Bearer \(apiKey)"
            ],
            body: formData.finalize()
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
}
