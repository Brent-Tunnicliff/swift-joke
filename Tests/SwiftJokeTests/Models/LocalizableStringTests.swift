// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing
@testable import SwiftJoke

struct LocalizableStringTests {
    @Test(arguments: LocalizableString.allCases)
    func resolvingStringDoesNotReturnKey(localizableString: LocalizableString) {
        #expect(localizableString.resolve() != localizableString.rawValue)
        #expect(localizableString.resolve().isEmpty == false)
    }
}
