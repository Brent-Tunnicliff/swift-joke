// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

// MARK: - CategoryWrapper

extension JokeAPIRequest {
    /// Category of joke to fetch.
    public struct CategoryWrapper: Codable, Hashable, Sendable {
        let value: Category
    }
}

extension JokeAPIRequest.CategoryWrapper {
    /// Fetch joke of any category.
    public static let `any` = JokeAPIRequest.CategoryWrapper(value: .any)

    /// Fetch joke from category of inputs.
    public static func custom(_ options: Set<JokeAPIRequest.OptionWrapper>) -> JokeAPIRequest.CategoryWrapper {
        JokeAPIRequest.CategoryWrapper(value: .custom(Set(options.map(\.wrappedValue))))
    }
}

extension JokeAPIRequest.CategoryWrapper: CaseIterable {
    /// A collection of all values of this type.
    public static let allCases: [JokeAPIRequest.CategoryWrapper] = JokeAPIRequest.Category.allCases
        .map(JokeAPIRequest.CategoryWrapper.init(value:))
}

// MARK: - Category

extension JokeAPIRequest {
    // We cannot use `EnumWrapper` as it does not support associated values.
    enum Category: Codable, Hashable, Sendable {
        case any
        case custom(Set<Option>)
    }
}

extension JokeAPIRequest.Category: CaseIterable {
    static let allCases: [JokeAPIRequest.Category] = {
        [.any] + getAllOptionCombinations(from: JokeAPIRequest.Option.allCases).map { .custom($0) }
    }()

    // Recursive function to get all possible option combinations.
    private static func getAllOptionCombinations(
        from options: some Collection<JokeAPIRequest.Option>
    ) -> Set<Set<JokeAPIRequest.Option>> {
        guard let first = options.first else {
            return [[]]
        }

        let remaining = options.dropFirst()
        let subCombinations = getAllOptionCombinations(from: remaining)
        return subCombinations.union(subCombinations.map { $0.union([first]) })
    }
}

// MARK: - Option

extension JokeAPIRequest {
    /// Category option.
    @EnumWrapper
    enum Option: String, CaseIterable, Codable {
        /// Christmas jokes.
        case christmas = "Christmas"

        /// Dark jokes.
        case dark = "Dark"

        /// Miscellaneous jokes.
        case miscellaneous = "Miscellaneous"

        /// Programming jokes.
        case programming = "Programming"

        /// Puns.
        case pun = "Pun"

        /// Spooky jokes.
        case spooky = "Spooky"
    }
}
