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
    /// The uuid instance that represents identifies the joke.
    public let value: UUID

    /// Initialises the object directly with the uuid.
    ///
    /// - Warning: Recommend to use ``init(source:name:)`` instead.
    public init(value: UUID) {
        self.value = value
    }
}

extension JokeIdentifier {
    /// Initialises an identifier based on the source and the internal identifier of that joke.
    ///
    /// Creates a uuid v5 as the combined identifier with source being the namespace.
    public init(source: SourceWrapper, name: String) {
        self.init(value: .v5(namespace: source.id, name: name))
    }
}

// MARK: Codable

extension JokeIdentifier: Codable {}

// MARK: - CustomDebugStringConvertible

extension JokeIdentifier: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        value.debugDescription
    }
}

// MARK: CustomStringConvertible

extension JokeIdentifier: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        value.description.lowercased()
    }
}

// MARK: Hashable

extension JokeIdentifier: Hashable {}

// MARK: Sendable

extension JokeIdentifier: Sendable {}
