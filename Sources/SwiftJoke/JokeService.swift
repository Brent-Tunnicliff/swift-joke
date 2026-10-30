// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials) && canImport(FoundationNetworking)
    import FoundationEssentials
    import FoundationNetworking
#else
    import Foundation
#endif

/// Service for getting jokes from various sources.
public final class JokeService: Sendable {
    /// Shared singleton instance.
    public static let shared = JokeService()

    private let decoder = JSONDecoder()
    private let networkService: any NetworkService

    init(networkService: some NetworkService) {
        self.networkService = networkService
    }

    private convenience init() {
        self.init(networkService: .default)
    }

    public func joke<Response>(from request: SingleJokeRequest<Response>) async throws(JokeError) -> Response {
        try await fetch(method: request.method)
    }

    public func jokes<Response>(
        from request: MultipleJokesRequest<Response>
    ) async throws(JokeError) -> [Response.SingleResponse] {
        let response: Response = try await fetch(method: request.method)
        return response.jokes
    }

    private func fetch<Response>(
        method: JokeRequestMethod
    ) async throws(JokeError) -> Response where Response: Decodable {
        switch method {
        case let .network(urlRequest):
            try await downloadJoke(from: urlRequest)
        }
    }
}

// MARK: - Download

extension JokeService {
    private func downloadJoke<Response>(
        from request: URLRequest
    ) async throws(JokeError) -> Response where Response: Decodable {
        let (data, response) = try await performDownload(from: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .placeholder
        }

        try checkForError(data: data, response: httpResponse)

        do {
            return try decoder.decode(Response.self, from: data)
        } catch let error as JokeError {
            throw error
        } catch let error as DecodingError {
            throw .decodingPayloadFailed
                .with(error: error)
        } catch {
            throw .unexpectedFailure
        }
    }

    private func performDownload(
        from request: URLRequest
    ) async throws(JokeError) -> (data: Data, response: URLResponse) {
        do {
            return try await networkService.data(for: request)
        } catch let error as JokeError {
            throw error
        } catch let error as URLError {
            throw switch error.code {
            case .timedOut: .networkRequestTimedOut
            case .networkConnectionLost: .networkConnectionLost
            case .notConnectedToInternet: .notConnectedToInternet
            default: .networkRequestFailed
                    .with(error: error)
            }
        } catch {
            throw .networkRequestFailed
                .with(error: error)
        }
    }

    private func checkForError(data: Data, response: HTTPURLResponse) throws(JokeError) {
        guard !response.statusCodeIsSuccess else {
            return
        }

        #warning("Flesh out conditions to throw on error")
        fatalError("Not yet implemented")
    }

    private func decodeResponse<Response>(data: Data) throws(JokeError) -> Response where Response: Decodable {
        do {
            return try decoder.decode(Response.self, from: data)
        } catch let error as JokeError {
            // If the custom Decoding logic has conditions to throw JokeError, we want to pass them directly through.
            throw error
        } catch {
            throw .decodingPayloadFailed
                .with(error: error)
        }
    }
}
