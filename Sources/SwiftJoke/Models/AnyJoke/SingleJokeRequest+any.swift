// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == AnyRequest.SingleResponse {
    /// Request a single joke from any supported source.
    public static var any: SingleJokeRequest {
        get throws(JokeError) {
            try any(from: Set(SourceWrapper.allCases))
        }
    }

    public static func any(from sources: Set<SourceWrapper>) throws(JokeError) -> SingleJokeRequest {
        switch sources.randomElement() {
        case .jokeAPI:
            SingleJokeRequest<JokeAPIRequest.SingleResponse>.jokeAPI().eraseToAny()
        default:
            throw JokeError.placeholder
        }
    }
}

extension SingleJokeRequest {
    fileprivate func eraseToAny() -> SingleJokeRequest<AnyRequest.SingleResponse> {
        SingleJokeRequest<AnyRequest.SingleResponse>(method: method)
    }
}

extension AnyRequest {
    public struct SingleResponse: SingleJokeResponse {
        public let id: JokeIdentifier
        public let joke: AnyJokeStructure
        public let source: SourceWrapper

        public init(id: JokeIdentifier, joke: AnyJokeStructure, source: SourceWrapper) {
            self.id = id
            self.joke = joke
            self.source = source
        }

        init(wrapped: any SingleJokeResponse) {
            self.init(
                id: wrapped.id,
                joke: wrapped.joke.asAny,
                source: wrapped.source
            )
        }
    }
}

extension AnyRequest.SingleResponse: Codable {
    private enum CodingKeys: CodingKey {
        case id, joke, source
    }

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
            throw JokeError.placeholder
        }
    }
}

extension SingleJokeResponse {
    public var asAny: AnyRequest.SingleResponse {
        AnyRequest.SingleResponse(wrapped: self)
    }
}
