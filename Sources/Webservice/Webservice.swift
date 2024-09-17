import Foundation
import AsyncHTTPClient

public struct Webservice {
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient = .shared) {
        self.httpClient = httpClient
    }
    
    public func request<Output: Response>(endpoint: Endpoint<Output>) async throws -> Output {
        let request = try endpoint.asRequest()
        let response = try await httpClient.execute(request, timeout: .seconds(Int64(endpoint.timeout)))
        
        if response.status == .ok {
            let decoder = Output.decoder
            let tenMegaBytes = 1024 * 1024 * 10
            let body = try await response.body.collect(upTo: tenMegaBytes)
            return try decoder.decode(Output.self, from: body)
        } else {
            throw WebserviceError.invalidStatusCode(Int(response.status.code))
        }
    }
    
    public func requestStreaming<Output: Response>(endpoint: Endpoint<Output>) -> AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let request = try endpoint.asRequest()
                    let response = try await httpClient.execute(request, timeout: .seconds(Int64(endpoint.timeout)))
                    
                    if response.status == .ok {
                        for try await chunk in response.body {
                            let chunkString = String(buffer: chunk)

                            let lines = chunkString.split(separator: "\n")
                            
                            for line in lines {
                                if line.hasPrefix("data: ") {
                                    let jsonData = line.dropFirst(6).trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    if jsonData == "[DONE]" {
                                        continuation.finish()
                                        return
                                    }
                                    
                                    if let data = jsonData.data(using: .utf8) {
                                        let decoder = Output.decoder
                                        let response = try decoder.decode(Output.self, from: data)
                                        continuation.yield(response)
                                    }
                                }
                            }
                        }
                    } else {
                        throw WebserviceError.invalidStatusCode(Int(response.status.code))
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
