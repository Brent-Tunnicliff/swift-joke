// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - JokeStructure

public protocol JokeStructure: Codable, Hashable, Sendable {
    /// Returns the full joke as a string without dealing with the different types.
    var joke: String { get }
    var asAny: AnyJokeStructure { get }
}
