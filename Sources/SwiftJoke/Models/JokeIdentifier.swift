// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Crypto
import UUIDv5

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

/// Unique identifier for joke response.
///
/// UUID v5 based on <https://stackoverflow.com/a/48076401>.
/// This allows us to have a deterministic identifier for each joke even though some sources don't return id's with their jokes.
public struct JokeIdentifier {
    public let value: UUID

    public init(value: UUID) {
        self.value = value
    }
}

extension JokeIdentifier {
    public init(source: SourceWrapper, name: String) {
        self.init(value: .v5(namespace: source.id, name: name))
    }
}

// MARK: Codable

extension JokeIdentifier: Codable {}

// MARK: - CustomDebugStringConvertible

extension JokeIdentifier: CustomDebugStringConvertible {
    public var debugDescription: String {
        value.debugDescription
    }
}

// MARK: CustomStringConvertible

extension JokeIdentifier: CustomStringConvertible {
    public var description: String {
        value.description.lowercased()
    }
}

// MARK: Hashable

extension JokeIdentifier: Hashable {}

// MARK: Sendable

extension JokeIdentifier: Sendable {}
