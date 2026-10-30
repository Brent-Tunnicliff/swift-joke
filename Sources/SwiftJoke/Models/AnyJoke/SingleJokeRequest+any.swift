// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

extension SingleJokeRequest where Response == AnyRequest.SingleResponse {
    /// Request a single joke from any supported source.
    public static var any: SingleJokeRequest {
        get throws {
            try any(from: Set(SourceWrapper.allCases))
        }
    }

    public static func any(from sources: Set<SourceWrapper>) throws -> SingleJokeRequest {
        switch sources.randomElement() {
        case .jokeAPI:
            SingleJokeRequest<JokeAPIRequest.SingleResponse>.jokeAPI().eraseToAny()
        case .officialJokeAPI:
            SingleJokeRequest<OfficialJokeAPIRequest.SingleResponse>.officialJokeAPIRequest().eraseToAny()
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

extension SingleJokeResponse {
    public var asAny: AnyRequest.SingleResponse {
        AnyRequest.SingleResponse(wrapped: self)
    }
}
