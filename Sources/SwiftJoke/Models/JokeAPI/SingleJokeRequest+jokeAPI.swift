// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == JokeAPIRequest.SingleResponse {
    public static func jokeAPI(
        authorizationToken: String? = nil,
        blacklistFlags: [JokeAPIRequest.BlacklistFlagWrapper] = [],
        categories: JokeAPIRequest.CategoryWrapper = .any,
        contains: String? = nil,
        idRange: ClosedRange<Int>? = nil,
        lang: JokeAPIRequest.LanguageWrapper = .english,
        safeMode: Bool = false,
        type: JokeAPIRequest.JokeTypeWrapper = .any
    ) -> SingleJokeRequest {
        let jokeAPIRequest = JokeAPIRequest(
            amount: 1,
            authorizationToken: authorizationToken,
            blacklistFlags: blacklistFlags,
            categories: categories,
            contains: contains,
            idRange: idRange,
            lang: lang,
            safeMode: safeMode,
            type: type
        )

        return SingleJokeRequest(method: jokeAPIRequest.asJokeRequestMethod)
    }
}

extension JokeAPIRequest {
    public struct SingleResponse: SingleJokeResponse {
        public let category: JokeAPIRequest.OptionWrapper
        public let flags: Flags
        public let id: JokeIdentifier
        public let internalId: Int
        public let joke: AnyJokeStructure
        public let language: LanguageWrapper
        public let safe: Bool
        public var source: SourceWrapper { JokeAPIRequest.source }

        public init(
            category: JokeAPIRequest.OptionWrapper,
            flags: Flags,
            id: Int,
            joke: AnyJokeStructure,
            language: LanguageWrapper,
            safe: Bool
        ) {
            self.category = category
            self.flags = flags
            self.id = JokeIdentifier(source: JokeAPIRequest.source, name: id.description)
            self.internalId = id
            self.joke = joke
            self.language = language
            self.safe = safe
        }
    }
}

extension JokeAPIRequest.SingleResponse {
    public struct Flags: Codable, Hashable, Sendable {
        public let explicit: Bool
        public let nsfw: Bool
        public let political: Bool
        public let racist: Bool
        public let religious: Bool
        public let sexist: Bool

        public init(explicit: Bool, nsfw: Bool, political: Bool, racist: Bool, religious: Bool, sexist: Bool) {
            self.explicit = explicit
            self.nsfw = nsfw
            self.political = political
            self.racist = racist
            self.religious = religious
            self.sexist = sexist
        }
    }
}

extension JokeAPIRequest.SingleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case category, error, flags, id, lang, safe, type

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

        let category = try container.decode(JokeAPIRequest.OptionWrapper.self, forKey: .category)
        let flags = try container.decode(Flags.self, forKey: .flags)
        let id = try container.decode(Int.self, forKey: .id)
        let language = try container.decode(JokeAPIRequest.LanguageWrapper.self, forKey: .lang)
        let safe = try container.decode(Bool.self, forKey: .safe)

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

        self.init(
            category: category,
            flags: flags,
            id: id,
            joke: joke,
            language: language,
            safe: safe
        )
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(category, forKey: .category)
        try container.encode(flags, forKey: .flags)
        try container.encode(internalId, forKey: .id)
        try container.encode(language, forKey: .lang)
        try container.encode(`safe`, forKey: .safe)

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
