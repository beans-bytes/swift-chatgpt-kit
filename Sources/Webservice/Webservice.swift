import Foundation
import AsyncHTTPClient

public struct Webservice {
    private let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient = .shared) {
        self.httpClient = httpClient
    }
    
    public func request<Output: Response>(endpoint: Endpoint<Output>) async throws -> Output {
        let request = try endpoint.asRequest()
        print("request \(request)")
        let response = try await httpClient.execute(request, timeout: .seconds(Int64(endpoint.timeout)))
        print("response \(response)")
        
        if response.status == .ok {
            let decoder = Output.decoder
            let tenMegaBytes = 1024 * 1024 * 10
            let body = try await response.body.collect(upTo: tenMegaBytes)
            return try decoder.decode(Output.self, from: body)
        } else {
            throw WebserviceError.invalidStatusCode(Int(response.status.code))
        }
    }
}
