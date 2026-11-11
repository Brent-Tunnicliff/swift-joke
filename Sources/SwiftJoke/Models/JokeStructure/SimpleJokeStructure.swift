// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// A simple joke that only contains the one parameter.
public struct SimpleJokeStructure {
    /// The full joke.
    public let joke: String

    /// Create an instance on ``SimpleJokeStructure``.
    public init(joke: String) {
        self.joke = joke
    }
}

// MARK: JokeStructure

extension SimpleJokeStructure: JokeStructure {
    /// Erase type to ``AnyJokeStructure``.
    public func eraseToAny() -> AnyJokeStructure {
        AnyJokeStructure(nested: .simple(self))
    }
}
