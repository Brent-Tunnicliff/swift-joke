// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension MultipleJokesRequest where Response == OfficialJokeAPIRequest.MultipleResponse {
    /// Request a number of random jokes from the [Official Joke API](https://github.com/15Dkatz/official_joke_api) source.
    ///
    /// We cannot specify a joke type when requesting a flexible number.
    ///
    /// - Parameter amount: The number of jokes to request.
    public static func officialJokeAPIRequest(amount: UInt8) -> MultipleJokesRequest {
        OfficialJokeAPIRequest(amount: .flexible(amount), jokeType: nil)
            .asMultipleJokesRequest
    }

    /// Request ten jokes from the [Official Joke API](https://github.com/15Dkatz/official_joke_api) source.
    ///
    /// - Parameters jokeType: The category of joke to fetch. Defaults to any.
    public static func officialJokeAPIRequest(
        jokeType: OfficialJokeAPIJokeTypeWrapper? = nil
    ) -> MultipleJokesRequest {
        OfficialJokeAPIRequest(amount: .hardcoded(.ten), jokeType: jokeType)
            .asMultipleJokesRequest
    }
}

extension OfficialJokeAPIRequest {
    fileprivate var asMultipleJokesRequest: MultipleJokesRequest<OfficialJokeAPIRequest.MultipleResponse> {
        MultipleJokesRequest(method: asJokeRequestMethod)
    }
}

extension OfficialJokeAPIRequest {
    public struct MultipleResponse: MultipleJokesResponse {
        public var jokes: [OfficialJokeAPIRequest.SingleResponse]

        public init(jokes: [OfficialJokeAPIRequest.SingleResponse]) {
            self.jokes = jokes
        }
    }
}

extension OfficialJokeAPIRequest.MultipleResponse {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(
            jokes: try container.decode([OfficialJokeAPIRequest.SingleResponse].self)
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(jokes)
    }
}
