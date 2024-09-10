import Foundation
import AsyncHTTPClient

public struct Webservice {
    public init() { }
    
    public func request<Output: Response>(endpoint: Endpoint<Output>) async throws -> Output {
        let request = try endpoint.asRequest()
        let response = try await HTTPClient.shared.execute(request, timeout: .seconds(Int64(endpoint.timeout)))
        
        if response.status == .ok {
            let decoder = Output.decoder
            let fiveMegaBytes = 1024 * 1024 * 5
            let body = try await response.body.collect(upTo: fiveMegaBytes)
            return try decoder.decode(Output.self, from: body)
        } else {
            throw WebserviceError.invalidStatusCode(Int(response.status.code))
        }
    }
}
