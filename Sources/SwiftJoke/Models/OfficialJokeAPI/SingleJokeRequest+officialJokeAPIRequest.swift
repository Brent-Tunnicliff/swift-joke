// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == OfficialJokeAPIRequest.SingleResponse {
    /// Request a joke from the [Official Joke API](https://github.com/15Dkatz/official_joke_api) source.
    ///
    /// - Parameter jokeType: The category of joke to fetch. Defaults to any.
    public static func officialJokeAPIRequest(
        jokeType: OfficialJokeAPIJokeTypeWrapper? = nil
    ) -> SingleJokeRequest {
        SingleJokeRequest(
            method: OfficialJokeAPIRequest(amount: .hardcoded(.one), jokeType: jokeType)
                .asJokeRequestMethod
        )
    }
}

extension OfficialJokeAPIRequest {
    public struct SingleResponse: SingleJokeResponse {
        public let id: JokeIdentifier
        public let internalId: Int
        public var joke: TwoPartJokeStructure
        public let jokeType: OfficialJokeAPIJokeTypeWrapper
        public var source: SourceWrapper { OfficialJokeAPIRequest.source }

        public init(
            id: Int,
            joke: TwoPartJokeStructure,
            jokeType: OfficialJokeAPIJokeTypeWrapper
        ) {
            self.id = JokeIdentifier(source: OfficialJokeAPIRequest.source, name: id.description)
            self.internalId = id
            self.joke = joke
            self.jokeType = jokeType
        }
    }
}

extension OfficialJokeAPIRequest.SingleResponse {
    private enum CodingKeys: CodingKey {
        case id, punchline, setup, type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let punchline = try container.decode(String.self, forKey: .punchline)
        let setup = try container.decode(String.self, forKey: .setup)
        let type = try container.decode(OfficialJokeAPIJokeTypeWrapper.self, forKey: .type)

        self.init(
            id: id,
            joke: TwoPartJokeStructure(setup: setup, delivery: punchline),
            jokeType: type
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(joke.delivery, forKey: .punchline)
        try container.encode(joke.setup, forKey: .setup)
        try container.encode(jokeType, forKey: .type)
    }
}
