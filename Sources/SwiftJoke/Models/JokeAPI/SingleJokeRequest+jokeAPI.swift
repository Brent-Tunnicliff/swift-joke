// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == JokeAPIRequest.SingleResponse {
    public static func jokeAPI(
        blacklistFlags: [JokeAPIRequest.BlacklistFlagWrapper] = [],
        categories: JokeAPIRequest.CategoryWrapper = .any,
        contains: String? = nil,
        idRange: ClosedRange<Int>? = nil,
        lang: JokeAPIRequest.LanguageWrapper = .english,
        type: JokeAPIRequest.JokeTypeWrapper = .any
    ) -> SingleJokeRequest {
        let jokeAPIRequest = JokeAPIRequest(
            amount: 1,
            blacklistFlags: blacklistFlags,
            categories: categories,
            contains: contains,
            idRange: idRange,
            lang: lang,
            type: type
        )

        return SingleJokeRequest(method: jokeAPIRequest.asJokeRequestMethod)
    }
}

extension JokeAPIRequest {
    public struct SingleResponse: SingleJokeResponse {
        public let id: JokeIdentifier
        public let internalId: Int
        public let joke: AnyJokeStructure
        public var source: SourceWrapper { JokeAPIRequest.source }

        public init(id internalId: Int, joke: AnyJokeStructure) {
            self.id = JokeIdentifier(source: JokeAPIRequest.source, name: internalId.description)
            self.internalId = internalId
            self.joke = joke
        }
    }
}

extension JokeAPIRequest.SingleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case error, id, type

        // if type == "single"
        case joke

        // if type == "twopart"
        case setup, delivery
    }

    private enum JokeType: String, Codable {
        case single
        case twopart
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isError = try container.decodeIfPresent(Bool.self, forKey: .error) ?? false
        guard !isError else {
            throw try JokeAPIRequest.ErrorPayload(from: decoder).asJokeError()
        }

        let id = try container.decode(Int.self, forKey: .id)
        let joke: AnyJokeStructure

        switch try container.decode(JokeType.self, forKey: .type) {
        case .single:
            joke = AnyJokeStructure(
                nested: .simple(
                    SimpleJokeStructure(
                        joke: try container.decode(String.self, forKey: .joke)
                    )
                )
            )
        case .twopart:
            joke = AnyJokeStructure(
                nested: .twoPart(
                    TwoPartJokeStructure(
                        setup: try container.decode(String.self, forKey: .setup),
                        delivery: try container.decode(String.self, forKey: .delivery)
                    )
                )
            )
        }

        self.init(id: id, joke: joke)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(internalId, forKey: .id)
        switch joke.nested {
        case let .simple(structure):
            try container.encode(JokeType.single, forKey: .type)
            try container.encode(structure.joke, forKey: .joke)
        case let .twoPart(structure):
            try container.encode(JokeType.twopart, forKey: .type)
            try container.encode(structure.setup, forKey: .setup)
            try container.encode(structure.delivery, forKey: .delivery)
        }
    }
}
