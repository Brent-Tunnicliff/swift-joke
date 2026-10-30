// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// A simple joke that only contains the one parameter.
public struct SimpleJokeStructure {
    /// The full joke.
    public let joke: String

    public var asAny: AnyJokeStructure {
        AnyJokeStructure(nested: .simple(self))
    }

    /// Create an instance on ``SimpleJokeStructure``.
    public init(joke: String) {
        self.joke = joke
    }
}

// MARK: JokeStructure

extension SimpleJokeStructure: JokeStructure {}

extension JokeStructure {
    var asSimpleJokeStructure: SimpleJokeStructure? {
        self as? SimpleJokeStructure
    }
}
