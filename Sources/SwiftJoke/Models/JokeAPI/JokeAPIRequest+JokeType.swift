// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

extension JokeAPIRequest {
    /// The structure type of the Joke.
    @EnumWrapper
    enum JokeType: CaseIterable, Codable {
        /// Any joke format.
        case any

        /// Single part jokes.
        case single

        /// Two part jokes containing setup and delivery.
        case twoPart
    }
}
