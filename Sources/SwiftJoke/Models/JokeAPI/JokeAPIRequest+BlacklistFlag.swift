// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

extension JokeAPIRequest {
    /// Jokes that match the specified flag(s) will not be served.
    @EnumWrapper
    enum BlacklistFlag: String, CaseIterable, Codable {
        /// Do not return explicit jokes.
        case explicit

        /// Do not return not safe for work (NSFW) jokes.
        case nsfw

        /// Do not return political jokes.
        case political

        /// Do not return racist jokes.
        case racist

        /// Do not return religious jokes.
        case religious

        /// Do not return sexist jokes.
        case sexist
    }
}
