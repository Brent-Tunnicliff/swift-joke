// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

/// Category of joke to fetch.
@EnumWrapper
enum OfficialJokeAPIJokeType: CaseIterable, Codable {
    /// Fetch a dad joke.
    case dad

    /// Fetch a general joke.
    case general

    /// Fetch a knock-knock joke.
    case knockKnock

    /// Fetch a programming joke.
    case programming
}
