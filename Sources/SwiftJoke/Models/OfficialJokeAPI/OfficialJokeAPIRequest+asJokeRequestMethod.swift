// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import URLHelpers

#if canImport(FoundationNetworking)
    import FoundationNetworking
#else
    import Foundation
#endif

extension OfficialJokeAPIRequest {
    var asJokeRequestMethod: JokeRequestMethod {
        .network(urlRequest)
    }
}

// MARK: - URLRequest

extension OfficialJokeAPIRequest {
    private static let baseURL = #url("https://official-joke-api.appspot.com/jokes")

    private var urlRequest: URLRequest {
        URLRequest(
            url: Self.baseURL.appending(components: pathComponents)
        )
    }
}

// MARK: Path components

extension OfficialJokeAPIRequest {
    private var pathComponents: [String] {
        switch amount.wrappedValue {
        case let .flexible(value): flexiblePathComponents(value: value)
        case let .hardcoded(value): hardcodedPathComponents(amountValue: value)
        }
    }

    func flexiblePathComponents(value: UInt8) -> [String] {
        [jokeType.pathComponent, value.description]
    }

    func hardcodedPathComponents(amountValue: OfficialJokeAPIRequest.HardcodedAmountWrapper) -> [String] {
        guard jokeType == nil else {
            return [jokeType.pathComponent, amountValue.pathComponent]
        }

        return switch amountValue.wrappedValue {
        case .one: [jokeType.pathComponent]
        case .ten: [amountValue.pathComponent]
        }
    }
}

extension OfficialJokeAPIRequest.HardcodedAmountWrapper {
    fileprivate var pathComponent: String {
        switch wrappedValue {
        case .one: "random"
        case .ten: "ten"
        }
    }
}

extension Optional<OfficialJokeAPIJokeTypeWrapper> {
    fileprivate var pathComponent: String {
        switch self?.wrappedValue {
        case nil: "random"
        case .dad: "dad"
        case .general: "general"
        case .knockKnock: "knock-knock"
        case .programming: "programming"
        }
    }
}
