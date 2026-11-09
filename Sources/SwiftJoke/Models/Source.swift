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

    var description: String {
        switch self {
        case .jokeAPI: "joke_api"
        }
    }

    var id: UUID {
        switch self {
        case .jokeAPI:
            #uuid("0DA39001-37FE-4C7C-9900-6EA792EFC979")
        }
    }
}
