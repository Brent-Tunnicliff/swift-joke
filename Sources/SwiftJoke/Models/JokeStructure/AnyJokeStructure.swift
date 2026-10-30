// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public struct AnyJokeStructure: JokeStructure {
    public var joke: String {
        nested.joke
    }

    public var asAny: AnyJokeStructure {
        self
    }

    let nested: Nested
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
