// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension MultipleJokesRequest where Response == JokeAPIRequest.MultipleResponse {
    /// Request configuration for getting multiple jokes from JokeAPI.
    ///
    /// - Parameters:
    ///     - amount: The amount of jokes to fetch. The API treats this as the maximum, it will return less if there are not enough based of the other queries.
    ///     - authorizationToken: Optional Authorization header token. Default value is `nil`.
    ///     - blacklistFlags: Define an array of flags to blacklist. Jokes that match the specified flag(s) will not be served. Default value is empty.
    ///     - categories: Category of joke to fetch. Default value is `any`.
    ///     - contains: If the search string filter is used, only jokes that contain the specified string will be returned. Default value is `nil`.
    ///     - idRange: If this filter is used, you will only get jokes that are within the provided range of IDs. Default value is `nil`.
    ///     - lang: The language of the joke. Default value `current`.
    ///     - safeMode: If enabled, JokeAPI will try its best to serve only jokes that are considered safe for everyone. Default value is `true`.
    ///     - type: Define the format of joke. Default value is `any`.
    /// - Returns: A configured request object for getting a multiple jokes from JokeAPI.
    public static func jokeAPI(
        amount: UInt8,
        authorizationToken: String? = nil,
        blacklistFlags: [JokeAPIRequest.BlacklistFlagWrapper] = [],
        categories: JokeAPIRequest.CategoryWrapper = .any,
        contains: String? = nil,
        idRange: ClosedRange<Int>? = nil,
        lang: JokeAPIRequest.LanguageWrapper = .current,
        safeMode: Bool = false,
        type: JokeAPIRequest.JokeTypeWrapper = .any
    ) -> MultipleJokesRequest {
        let jokeAPIRequest = JokeAPIRequest(
            amount: amount,
            authorizationToken: authorizationToken,
            blacklistFlags: blacklistFlags,
            categories: categories,
            contains: contains,
            idRange: idRange,
            lang: lang,
            safeMode: safeMode,
            type: type
        )

        return MultipleJokesRequest(method: jokeAPIRequest.asJokeRequestMethod)
    }
}

extension JokeAPIRequest {
    /// The jokes response returned upon successful request.
    public struct MultipleResponse: MultipleJokesResponse {
        /// The requested jokes.
        public let jokes: [SingleResponse]
    }
}

extension JokeAPIRequest.MultipleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case error, jokes
    }

    /// Creates a new instance by decoding from the given decoder.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isError = try container.decodeIfPresent(Bool.self, forKey: .error) ?? false
        guard !isError else {
            throw try JokeAPIRequest.ErrorPayload(from: decoder).asJokeError()
        }

        self.init(
            jokes: try container.decode([JokeAPIRequest.SingleResponse].self, forKey: .jokes)
        )
    }

    /// Encodes this value into the given encoder.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jokes, forKey: .jokes)
    }
}
