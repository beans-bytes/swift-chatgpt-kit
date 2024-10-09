import Foundation

public struct Webservice {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<Output: Response>(endpoint: Endpoint<Output>) async throws -> Output {
        let urlRequest = try endpoint.asURLRequest()

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WebserviceError.invalidResponse
        }

        print("request \(String(data: urlRequest.httpBody!, encoding: .utf8))")
        print("response \(String(data: data, encoding: .utf8))")
        
        if httpResponse.statusCode == 200 {
            let decoder = Output.decoder
            return try decoder.decode(Output.self, from: data)
        } else {
            throw WebserviceError.invalidStatusCode(httpResponse.statusCode)
        }
    }
    
    public func request(endpoint: Endpoint<Data>) async throws -> Data {
        let urlRequest = try endpoint.asURLRequest()

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WebserviceError.invalidResponse
        }

        if httpResponse.statusCode == 200 {
            return data
        } else {
            throw WebserviceError.invalidStatusCode(httpResponse.statusCode)
        }
    }

    public func requestStreaming<Output: Response>(endpoint: Endpoint<Output>) -> AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let urlRequest = try endpoint.asURLRequest()
                    let (bytes, response) = try await session.bytes(for: urlRequest)

                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw WebserviceError.invalidResponse
                    }

                    if httpResponse.statusCode == 200 {
                        for try await line in bytes.lines {
                            if line.hasPrefix("data: ") {
                                let jsonDataString = line.dropFirst(6).trimmingCharacters(in: .whitespacesAndNewlines)

                                if jsonDataString == "[DONE]" {
                                    continuation.finish()
                                    return
                                }

                                if let data = jsonDataString.data(using: .utf8) {
                                    let decoder = Output.decoder
                                    let response = try decoder.decode(Output.self, from: data)
                                    continuation.yield(response)
                                }
                            }
                        }
                    } else {
                        throw WebserviceError.invalidStatusCode(httpResponse.statusCode)
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
