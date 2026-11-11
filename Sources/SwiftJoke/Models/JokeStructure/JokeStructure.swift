// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - JokeStructure

/// Common joke structure type.
public protocol JokeStructure: Codable, Hashable, Sendable {
    /// Returns the full joke as a string without dealing with the different types.
    var joke: String { get }

    /// Erase type to ``AnyJokeStructure``.
    func eraseToAny() -> AnyJokeStructure
}
