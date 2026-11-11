// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == AnyRequest.SingleResponse {
    /// Request a single joke from any supported source.
    public static var any: SingleJokeRequest {
        get throws(JokeError) {
            try any(from: Set(SourceWrapper.allCases))
        }
    }

    /// Request a single joke from any of the input sources.
    public static func any(from sources: Set<SourceWrapper>) throws(JokeError) -> SingleJokeRequest {
        switch sources.randomElement() {
        case .jokeAPI:
            SingleJokeRequest<JokeAPIRequest.SingleResponse>.jokeAPI().eraseToAny()
        default:
            throw .unexpectedJokeSource
        }
    }
}

extension SingleJokeRequest {
    fileprivate func eraseToAny() -> SingleJokeRequest<AnyRequest.SingleResponse> {
        SingleJokeRequest<AnyRequest.SingleResponse>(method: method)
    }
}

extension AnyRequest {
    /// The joke response returned upon successful request.
    public struct SingleResponse: SingleJokeResponse {
        /// The unique identifier of the joke object.
        public let id: JokeIdentifier

        /// The requested joke.
        public let joke: AnyJokeStructure

        /// Source of the joke.
        ///
        /// Where the joke came from.
        public let source: SourceWrapper

        /// Initialises an instance of the response.
        public init(id: JokeIdentifier, joke: AnyJokeStructure, source: SourceWrapper) {
            self.id = id
            self.joke = joke
            self.source = source
        }

        init(wrapped: any SingleJokeResponse) {
            self.init(
                id: wrapped.id,
                joke: wrapped.joke.eraseToAny(),
                source: wrapped.source
            )
        }
    }
}

extension AnyRequest.SingleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case id, joke, source
    }

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// Attempts to decode as a `AnyRequest.SingleResponse` type, as well as any other known source type.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // If it is an encoded `AnyRequest.SingleResponse`
        if let source = try container.decodeIfPresent(SourceWrapper.self, forKey: .source) {
            self.init(
                id: try container.decode(JokeIdentifier.self, forKey: .id),
                joke: try container.decode(AnyJokeStructure.self, forKey: .joke),
                source: source
            )
        } else if let jokeAPI = try? JokeAPIRequest.SingleResponse(from: decoder) {
            self.init(wrapped: jokeAPI)
        } else {
            throw JokeError.unexpectedJokeSource
        }
    }
}
