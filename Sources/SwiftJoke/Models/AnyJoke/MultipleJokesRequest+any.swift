// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension MultipleJokesRequest where Response == AnyRequest.MultipleResponse {
    /// Request jokes from any supported source.
    ///
    /// All jokes will come from the same source.
    ///
    /// - Parameter amount: The number of jokes to request.
    public static func any(amount: UInt8) throws(JokeError) -> MultipleJokesRequest {
        try any(amount: amount, from: Set(SourceWrapper.allCases))
    }

    public static func any(amount: UInt8, from sources: Set<SourceWrapper>) throws(JokeError) -> MultipleJokesRequest {
        switch sources.randomElement() {
        case .jokeAPI:
            MultipleJokesRequest<JokeAPIRequest.MultipleResponse>.jokeAPI(amount: amount).eraseToAny()
        case .officialJokeAPI:
            MultipleJokesRequest<OfficialJokeAPIRequest.MultipleResponse>.officialJokeAPIRequest(amount: amount)
                .eraseToAny()
        default:
            throw JokeError.placeholder
        }
    }
}

extension MultipleJokesRequest {
    fileprivate func eraseToAny() -> MultipleJokesRequest<AnyRequest.MultipleResponse> {
        MultipleJokesRequest<AnyRequest.MultipleResponse>(method: method)
    }
}

extension AnyRequest {
    public struct MultipleResponse: MultipleJokesResponse {
        public let jokes: [AnyRequest.SingleResponse]

        public init(jokes: [AnyRequest.SingleResponse]) {
            self.jokes = jokes
        }

        init(wrapped: any MultipleJokesResponse) {
            self.init(jokes: wrapped.jokes.map(\.asAny))
        }
    }
}

extension MultipleJokesResponse {
    public var asAny: AnyRequest.MultipleResponse {
        AnyRequest.MultipleResponse(wrapped: self)
    }
}
