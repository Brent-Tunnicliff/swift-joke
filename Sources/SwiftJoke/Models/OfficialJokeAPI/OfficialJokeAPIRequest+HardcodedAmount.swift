// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

extension OfficialJokeAPIRequest {
    /// Amount of jokes to retrieve in the request.
    ///
    /// When getting a joke with `JokeType` we can only use hard coded amount.
    @EnumWrapper
    enum HardcodedAmount: UInt8, CaseIterable, Codable {
        case one = 1
        case ten = 10
    }
}
