// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

// MARK: - Language

extension JokeAPIRequest {
    /// Supported languages.
    @EnumWrapper
    enum Language: String, CaseIterable, Codable {
        /// Jokes in Czech language.
        case czech = "cs"

        /// Jokes in English language.
        case english = "en"

        /// Jokes in French language.
        case french = "fr"

        /// Jokes in German language.
        case german = "de"

        /// Jokes in Portuguese language.
        case portuguese = "pt"

        /// Jokes in Spanish language.
        case spanish = "es"
    }
}

extension JokeAPIRequest.LanguageWrapper {
    // Default to english if there is no match.
    private static let `default` = JokeAPIRequest.LanguageWrapper.english

    /// Returns the current language for the application.
    public static var current: JokeAPIRequest.LanguageWrapper {
        let locales: [Locale]

        if #available(macOS 26, iOS 26, tvOS 26, watchOS 26, *) {
            locales = [Locale.autoupdatingCurrent] + Locale.preferredLocales
        } else {
            locales = [Locale.autoupdatingCurrent]
        }

        for locale in locales {
            if let language = JokeAPIRequest.LanguageWrapper(alpha2Identifier: locale.alpha2Identifier) {
                return language
            }
        }

        return .default
    }

    /// Create from Locale.
    ///
    /// If does not match a supported language then sets it as English.
    public init(locale: Locale) {
        guard let value = JokeAPIRequest.LanguageWrapper(alpha2Identifier: locale.alpha2Identifier) else {
            self = .default
            return
        }

        self = value
    }

    init?(alpha2Identifier: String?) {
        guard let value = JokeAPIRequest.Language.allCases.first(where: { $0.rawValue == alpha2Identifier }) else {
            // Default to english if there is no match.
//            self.init(wrappedValue: .english)
            return nil
        }

        self.init(wrappedValue: value)
    }
}

extension Locale {
    fileprivate var alpha2Identifier: String? {
        language.alpha2Identifier
    }
}

extension Locale.Language {
    fileprivate var alpha2Identifier: String? {
        languageCode?.identifier(.alpha2)
    }
}
