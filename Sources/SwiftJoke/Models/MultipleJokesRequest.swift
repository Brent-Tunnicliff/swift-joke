// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// The request configuration for fetching multiple jokes from a source.
public struct MultipleJokesRequest<Response> where Response: MultipleJokesResponse {
    let method: JokeRequestMethod
}
