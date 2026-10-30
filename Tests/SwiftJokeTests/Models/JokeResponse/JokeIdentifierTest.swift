// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import SwiftJoke

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

struct JokeIdentifierTest {
    // I found these example input and output in various StackOverflow answers about UUID v5.
    @Test(arguments: [
        (
            source: SourceWrapper.jokeAPI,
            name: "5a23dbfb2626b400190998fc-5pCAvA7h8k9JuErRn",
            expectedResult: "2372230b-8344-5dc2-9754-f9903b03a024"
        ),
        (
            source: SourceWrapper.jokeAPI,
            name: "string",
            expectedResult: "a3c21a3d-b920-529c-842c-6c864267486b"
        ),
    ])
    func initWithSourceAndName(source: SourceWrapper, name: String, expectedResult: String) throws {
        let expectedResult = try JokeIdentifier(value: #require(UUID(uuidString: expectedResult)))
        #expect(JokeIdentifier(source: source, name: name) == expectedResult)
    }

    @Test
    func initWithDifferentSourcesAreUniqueIfNameIsTheSame() {
        let allSources = SourceWrapper.allCases
        let name = "swift-joke"
        var results: [JokeIdentifier: [SourceWrapper]] = [:]
        for source in allSources {
            let identifier = JokeIdentifier(source: source, name: name)
            let previousSources = results[identifier] ?? []
            results[identifier] = previousSources + [source]
        }

        #expect(results.count == allSources.count)

        for (identifier, sources) in results {
            #expect(
                sources.count == 1,
                "identifier '\(identifier)' for sources \(sources.map(\.description).joined(separator: ", "))"
            )
        }
    }

    @Test(arguments: [
        (
            lhs: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
            rhs: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
            expectedResult: true
        ),
        (
            lhs: "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
            rhs: "6ba7b811-9dad-11d1-80b4-00c04fd430c8",
            expectedResult: false
        ),
    ])
    func equals(lhs: String, rhs: String, expectedResult: Bool) throws {
        let lhs = try JokeIdentifier(value: #require(UUID(uuidString: lhs)))
        let rhs = try JokeIdentifier(value: #require(UUID(uuidString: rhs)))
        #expect((lhs == rhs) == expectedResult)
    }
}
