// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == JokeAPIRequest.SingleResponse {
    /// Request configuration for getting a joke from JokeAPI.
    ///
    /// - Parameters:
    ///     - authorizationToken: Optional Authorization header token. Default value is `nil`.
    ///     - blacklistFlags: Define an array of flags to blacklist. Jokes that match the specified flag(s) will not be served. Default value is empty.
    ///     - categories: Category of joke to fetch. Default value is `any`.
    ///     - contains: If the search string filter is used, only jokes that contain the specified string will be returned. Default value is `nil`.
    ///     - idRange: If this filter is used, you will only get jokes that are within the provided range of IDs. Default value is `nil`.
    ///     - lang: The language of the joke. Default value `current`.
    ///     - safeMode: If enabled, JokeAPI will try its best to serve only jokes that are considered safe for everyone. Default value is `true`.
    ///     - type: Define the format of joke. Default value is `any`.
    /// - Returns: A configured request object for getting a single joke from JokeAPI.
    public static func jokeAPI(
        authorizationToken: String? = nil,
        blacklistFlags: [JokeAPIRequest.BlacklistFlagWrapper] = [],
        categories: JokeAPIRequest.CategoryWrapper = .any,
        contains: String? = nil,
        idRange: ClosedRange<Int>? = nil,
        lang: JokeAPIRequest.LanguageWrapper = .current,
        safeMode: Bool = true,
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
    /// The joke response returned upon successful request.
    public struct SingleResponse: SingleJokeResponse {
        /// Category of joke.
        public let category: JokeAPIRequest.OptionWrapper

        /// Flags associated with this joke.
        public let flags: Flags

        /// The unique identifier of the joke object.
        public let id: JokeIdentifier

        /// The unique identifier of the joke object defined by JokeAPI.
        public let internalId: Int

        /// The requested joke.
        public let joke: AnyJokeStructure

        /// The language of the joke.
        public let language: LanguageWrapper

        /// Is the joke considered safe for everyone.
        public let safe: Bool

        /// Source of the joke.
        ///
        /// Where the joke came from.
        public var source: SourceWrapper { JokeAPIRequest.source }

        /// Initialises an instance of the response.
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
    /// Flags associated with this joke.
    public struct Flags: Codable, Hashable, Sendable {
        /// Defines if the joke is considered explicit.
        public let explicit: Bool

        /// Defines if the joke is considered not safe for work (NSFW).
        public let nsfw: Bool

        /// Defines if the joke is considered political.
        public let political: Bool

        /// Defines if the joke is considered racist.
        public let racist: Bool

        /// Defines if the joke is considered religious.
        public let religious: Bool

        /// Defines if the joke is considered sexist.
        public let sexist: Bool

        /// Initialises an instance of Flags.
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

    /// Creates a new instance by decoding from the given decoder.
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

    /// Encodes this value into the given encoder.
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
