// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Two part jokes containing setup and delivery.
public struct TwoPartJokeStructure {
    /// The setup of the joke.
    ///
    /// This is the initial value to present.
    public let setup: String

    /// The delivery of the joke.
    ///
    /// This is to be shown after the setup.
    public let delivery: String

    public var asAny: AnyJokeStructure {
        AnyJokeStructure(nested: .twoPart(self))
    }

    /// Create an instance on ``TwoPartJokeStructure``.
    public init(setup: String, delivery: String) {
        self.setup = setup
        self.delivery = delivery
    }
}

// MARK: JokeStructure

extension TwoPartJokeStructure: JokeStructure {
    /// Returns the setup and delivery combined.
    public var joke: String {
        "\(setup) \(delivery)"
    }
}

extension JokeStructure {
    public var asTwoPartJokeStructure: TwoPartJokeStructure? {
        self as? TwoPartJokeStructure
    }
}
