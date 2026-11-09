// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Configuration for requesting jokes from the [Official Joke API](https://github.com/15Dkatz/official_joke_api) source.
public struct OfficialJokeAPIRequest {
    /// The maximum amount of jokes to request at once.
    public let amount: AmountWrapper

    /// The category of joke to fetch.
    public let jokeType: OfficialJokeAPIJokeTypeWrapper?
}
