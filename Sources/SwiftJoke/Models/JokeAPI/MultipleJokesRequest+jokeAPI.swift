// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension MultipleJokesRequest where Response == JokeAPIRequest.MultipleResponse {
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
    public struct MultipleResponse: MultipleJokesResponse {
        public let jokes: [SingleResponse]
    }
}

extension JokeAPIRequest.MultipleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case error, jokes
    }

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

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jokes, forKey: .jokes)
    }
}
