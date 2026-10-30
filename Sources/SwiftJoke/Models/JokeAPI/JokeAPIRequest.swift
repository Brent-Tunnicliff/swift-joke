// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Configuration for requesting jokes from the [JokeAPI](https://sv443.net/jokeapi/v2/) source.
public struct JokeAPIRequest {
    public let amount: UInt8
    public let authorizationToken: String?
    public let blacklistFlags: [BlacklistFlagWrapper]
    public let categories: CategoryWrapper
    public let contains: String?
    public let idRange: ClosedRange<Int>?
    public let lang: LanguageWrapper
    public let safeMode: Bool
    public let type: JokeTypeWrapper
}
