// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

public protocol SingleJokeResponse<Structure>: Codable, Hashable, Identifiable, Sendable
where Structure: JokeStructure {
    associatedtype Structure

    var id: JokeIdentifier { get }
    var joke: Structure { get }
    var source: SourceWrapper { get }
}
