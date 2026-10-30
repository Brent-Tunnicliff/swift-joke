// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials) && canImport(FoundationNetworking)
    import FoundationEssentials
    import FoundationNetworking
#else
    import Foundation
#endif

// MARK: - NetworkService

protocol NetworkService: Sendable {
    func data(for request: URLRequest) async throws -> (data: Data, response: URLResponse)
}

// MARK: - DefaultNetworkService

final class DefaultNetworkService {
    static let shared = DefaultNetworkService()

    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        var httpAdditionalHeaders = configuration.httpAdditionalHeaders ?? [:]

        // Setting the "From" header so joke sources can contact me if there are issues.
        // <https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/From>
        httpAdditionalHeaders["From"] = "brent@tunnicliff.dev"

        configuration.httpAdditionalHeaders = httpAdditionalHeaders
        self.session = URLSession(configuration: configuration)
    }
}

extension DefaultNetworkService: NetworkService {
    func data(for request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        try await session.data(for: request)
    }
}

extension NetworkService where Self == DefaultNetworkService {
    static var `default`: Self { .shared }
}
