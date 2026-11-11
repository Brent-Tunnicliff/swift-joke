// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// The jokes response returned upon successful request.
public protocol MultipleJokesResponse<SingleResponse>: Codable, Hashable, Sendable
where SingleResponse: SingleJokeResponse {
    associatedtype SingleResponse

    var jokes: [SingleResponse] { get }
}
