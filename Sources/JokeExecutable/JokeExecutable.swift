// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import ArgumentParser
import SwiftJoke

@main
struct JokeExecutable: AsyncParsableCommand {
    mutating func run() async throws {
        let jokeService = JokeService()
        let joke = try await jokeService.joke(from: .jokeAPI())
        print("Joke: '\(joke)'")
    }
}
