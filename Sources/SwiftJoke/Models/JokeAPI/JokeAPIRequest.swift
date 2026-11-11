// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Configuration for requesting jokes from the [JokeAPI](https://sv443.net/jokeapi/v2/) source.
public struct JokeAPIRequest {
    /// The amount of jokes to fetch.
    ///
    /// The API treats this as the maximum, it will return less if there are not enough based of the other queries.
    public let amount: UInt8

    /// Optional Authorization header token.
    ///
    /// The API works without this, only use if you have been provided one by `jokeapi`.
    /// <https://sv443.net/jokeapi/v2/#api-tokens>
    public let authorizationToken: String?

    /// Define flags to blacklist.
    ///
    /// Jokes that match the specified flag(s) will not be served.
    public let blacklistFlags: [BlacklistFlagWrapper]

    /// Category of joke to fetch.
    public let categories: CategoryWrapper

    /// If the search string filter is used, only jokes that contain the specified string will be returned.
    public let contains: String?

    /// If this filter is used, you will only get jokes that are within the provided range of IDs.
    public let idRange: ClosedRange<Int>?

    /// The language of the joke.
    public let lang: LanguageWrapper

    /// If enabled, JokeAPI will try its best to serve only jokes that are considered safe for everyone.
    public let safeMode: Bool

    /// Define the format of joke.
    public let type: JokeTypeWrapper
}
