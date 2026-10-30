// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper
import UUIDHelpers

#if canImport(FoundationEssentials)
    @diagnose(UnusedImportAccess, as: ignored) public import FoundationEssentials
#else
    @diagnose(UnusedImportAccess, as: ignored) public import Foundation
#endif

/// A source system for providing jokes.
@EnumWrapper
enum Source: CaseIterable, Codable, CustomStringConvertible, Identifiable {
    /// Represents the source [JokeAPI](https://sv443.net/jokeapi/v2/).
    case jokeAPI

    /// Represents the source [Official Joke API](https://github.com/15Dkatz/official_joke_api).
    case officialJokeAPI

    var description: String {
        switch self {
        case .jokeAPI: "joke_api"
        case .officialJokeAPI: "official_joke_api"
        }
    }

    var id: UUID {
        switch self {
        case .jokeAPI:
            #uuid("0DA39001-37FE-4C7C-9900-6EA792EFC979")
        case .officialJokeAPI:
            #uuid("0DA39002-37FE-4C7C-9900-6EA792EFC979")
        }
    }
}
