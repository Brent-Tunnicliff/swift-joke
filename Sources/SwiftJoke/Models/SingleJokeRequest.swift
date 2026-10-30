// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// The request configuration for fetching a single joke from a source.
public struct SingleJokeRequest<Response> where Response: SingleJokeResponse {
    let method: JokeRequestMethod
}
