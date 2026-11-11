// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension MultipleJokesRequest where Response == AnyRequest.MultipleResponse {
    /// Request jokes from any supported source.
    ///
    /// All jokes will come from the same source.
    ///
    /// - Parameter amount: The number of jokes to request.
    /// - Throws: If there are no available sources.
    /// - Returns: The request object for fetching multiple jokes.
    public static func any(amount: UInt8) throws(JokeError) -> MultipleJokesRequest {
        try any(amount: amount, from: Set(SourceWrapper.allCases))
    }

    /// Request jokes from any of the input sources.
    ///
    /// All jokes will come from the same source.
    ///
    /// - Parameters:
    ///     - amount: The number of jokes to request.
    ///     - sources: The set of sources that the jokes will come from.
    /// - Throws: If there are no available sources.
    /// - Returns: The request object for fetching multiple jokes.
    public static func any(amount: UInt8, from sources: Set<SourceWrapper>) throws(JokeError) -> MultipleJokesRequest {
        switch sources.randomElement() {
        case .jokeAPI:
            MultipleJokesRequest<JokeAPIRequest.MultipleResponse>.jokeAPI(amount: amount).eraseToAny()
        default:
            throw .unexpectedJokeSource
        }
    }
}

extension MultipleJokesRequest {
    fileprivate func eraseToAny() -> MultipleJokesRequest<AnyRequest.MultipleResponse> {
        MultipleJokesRequest<AnyRequest.MultipleResponse>(method: method)
    }
}

extension AnyRequest {
    /// The jokes response returned upon successful request.
    public struct MultipleResponse: MultipleJokesResponse {
        /// The requested jokes.
        public let jokes: [AnyRequest.SingleResponse]

        /// Initialise the response with the input jokes.
        public init(jokes: [AnyRequest.SingleResponse]) {
            self.jokes = jokes
        }

        init(wrapped: any MultipleJokesResponse) {
            self.init(jokes: wrapped.jokes.map(AnyRequest.SingleResponse.init(wrapped:)))
        }
    }
}
