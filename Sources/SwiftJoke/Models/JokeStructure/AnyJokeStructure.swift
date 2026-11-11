// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Type erased Joke structure.
public struct AnyJokeStructure: JokeStructure {
    /// Returns the full joke as a string without dealing with the different types.
    public var joke: String {
        nested.joke
    }

    let nested: Nested

    /// Returns self.
    public func eraseToAny() -> AnyJokeStructure {
        self
    }
}

extension AnyJokeStructure {
    enum Nested: Codable, Hashable, Sendable {
        case simple(SimpleJokeStructure)
        case twoPart(TwoPartJokeStructure)

        var joke: String {
            switch self {
            case let .simple(structure): structure.joke
            case let .twoPart(structure): structure.joke
            }
        }
    }
}

extension AnyJokeStructure {
    /// Initialise a simple instance with a joke.
    public init(joke: String) {
        self.nested = .simple(
            SimpleJokeStructure(joke: joke)
        )
    }
}

extension AnyJokeStructure {
    func asSimpleJokeStructure() -> SimpleJokeStructure? {
        switch nested {
        case let .simple(value): value
        case .twoPart: nil
        }
    }

    func asTwoPartJokeStructure() -> TwoPartJokeStructure? {
        switch nested {
        case .simple: nil
        case let .twoPart(value): value
        }
    }
}
