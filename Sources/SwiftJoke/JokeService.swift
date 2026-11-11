// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials) && canImport(FoundationInternationalization) && canImport(FoundationNetworking)
    import FoundationEssentials
    import FoundationInternationalization
    import FoundationNetworking
#else
    import Foundation
#endif

/// Service for getting jokes from various sources.
public final class JokeService: Sendable {
    private let decoder = JSONDecoder()
    private let networkService: any NetworkService

    /// Initialise instance of ``JokeService``.
    public convenience init() {
        self.init(networkService: .default)
    }

    init(networkService: some NetworkService) {
        self.networkService = networkService
    }

    /// Get a joke from any source.
    public func joke() async throws(JokeError) -> AnyRequest.SingleResponse {
        try await joke(from: .any)
    }

    /// Get a joke with the defined request configuration.
    public func joke<Response>(from request: SingleJokeRequest<Response>) async throws(JokeError) -> Response {
        try await fetch(method: request.method)
    }

    /// Get a multiple jokes with the defined request configuration.
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
        if let httpResponse = response as? HTTPURLResponse {
            try checkForError(
                data: data,
                response: httpResponse,
                responseType: Response.self
            )
        }

        return try decodeResponse(data: data)
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
            default:
                .networkRequestFailed.with(error: error)
            }
        } catch {
            throw .networkRequestFailed.with(error: error)
        }
    }

    private func checkForError<Response>(
        data: Data,
        response: HTTPURLResponse,
        responseType: Response.Type
    ) throws(JokeError) where Response: Decodable {
        guard !response.statusCodeIsSuccess else {
            return
        }

        var userInfo: [String: String] = [
            JokeError.UserInfoKey.status: response.statusCode.description
        ]

        do {
            // If the response type handles error types too, then attach to the user info.
            let errorPayload = try decoder.decode(responseType, from: data)
            userInfo[JokeError.UserInfoKey.causedBy] = "\(errorPayload)"
        } catch let error as JokeError {
            userInfo[JokeError.UserInfoKey.causedBy] = error.description
        } catch {
            // Ignore
        }

        throw JokeError.networkResponseErrorStatus
            .with(userInfo: userInfo)
    }

    private func decodeResponse<Response>(data: Data) throws(JokeError) -> Response where Response: Decodable {
        do {
            return try decoder.decode(Response.self, from: data)
        } catch let error as JokeError {
            // If the custom Decoding logic has conditions to throw JokeError, we want to pass them directly through.
            throw error
        } catch let error as DecodingError {
            throw .decodingPayloadFailed
                .with(error: error)
        } catch {
            throw .unexpectedFailure
                .with(error: error)
        }
    }
}
