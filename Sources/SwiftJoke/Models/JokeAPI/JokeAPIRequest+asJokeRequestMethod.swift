// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import URLHelpers

#if canImport(FoundationEssentials) && canImport(FoundationNetworking)
    import FoundationEssentials
    import FoundationNetworking
#else
    import Foundation
#endif

extension JokeAPIRequest {
    var asJokeRequestMethod: JokeRequestMethod {
        .network(urlRequest)
    }
}

// MARK: - URLRequest

extension JokeAPIRequest {
    private static let baseURL = #url("https://v2.jokeapi.dev/joke")

    private var urlRequest: URLRequest {
        let queryItems: [URLQueryItem] = [
            amountQueryItem,
            blacklistFlags.queryItem,
            containsQueryItem,
            idRangeQueryItem,
            lang.queryItem,
            safeModeQueryItem,
            type.queryItem,
        ].compactMap { $0 }

        let url = Self.baseURL
            .appending(component: categories.pathComponent)
            .appending(queryItems: queryItems)

        var request = URLRequest(url: url)

        if let authorizationToken {
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

// MARK: Path components

extension JokeAPIRequest.CategoryWrapper {
    fileprivate var pathComponent: String {
        switch value {
        case .any: "Any"
        case let .custom(options): options.pathComponent
        }
    }
}

extension Collection where Element == JokeAPIRequest.Option {
    fileprivate var pathComponent: String {
        guard !isEmpty else {
            // If none were defined then map to any.
            return JokeAPIRequest.CategoryWrapper.any.pathComponent
        }

        // The contract expects the path to include all the categories separated by a comma e.g.
        // `https://v2.jokeapi.dev/joke/Programming,Miscellaneous,Dark,Pun,Spooky,Christmas`
        return map(\.rawValue).sorted().joined(separator: ",")
    }
}

// MARK: - Query items

extension JokeAPIRequest {
    fileprivate var amountQueryItem: URLQueryItem {
        URLQueryItem(name: "amount", value: amount.description)
    }

    fileprivate var containsQueryItem: URLQueryItem? {
        contains.map {
            URLQueryItem(name: "contains", value: $0)
        }
    }

    fileprivate var idRangeQueryItem: URLQueryItem? {
        idRange.map {
            URLQueryItem(
                name: "idRange",
                value: "\($0.lowerBound)-\($0.upperBound)"
            )
        }
    }

    fileprivate var safeModeQueryItem: URLQueryItem {
        URLQueryItem(name: "safe-mode", value: nil)
    }
}

extension Collection where Element == JokeAPIRequest.BlacklistFlagWrapper {
    fileprivate var queryItem: URLQueryItem? {
        guard !isEmpty else {
            return nil
        }

        // The contract expects the value to include all the blacklist flags separated by a comma e.g.
        // `https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,religious,political,racist,sexist,explicit`
        return URLQueryItem(
            name: "blacklistFlags",
            value: map(\.rawValue).joined(separator: ",")
        )
    }
}

extension JokeAPIRequest.JokeTypeWrapper {
    fileprivate var queryItem: URLQueryItem? {
        let value: String
        switch wrappedValue {
        case .any:
            return nil
        case .single:
            value = "single"
        case .twoPart:
            value = "twopart"
        }

        return URLQueryItem(name: "type", value: value)
    }
}

extension JokeAPIRequest.LanguageWrapper {
    fileprivate var queryItem: URLQueryItem {
        URLQueryItem(name: "lang", value: rawValue)
    }
}
