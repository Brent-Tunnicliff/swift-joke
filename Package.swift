// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2025 Brent Tunnicliff <brent@tunnicliff.dev>

import PackageDescription

let package = Package(
    name: "swift-joke",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "SwiftJoke",
            targets: ["SwiftJoke"]
        ),
        .executable(
            name: "joke",
            targets: ["joke"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/Brent-Tunnicliff/enum-wrapper-macro", branch: "initial_setup"),
        .package(url: "https://github.com/Brent-Tunnicliff/lib-url-macro-swift.git", branch: "foundation_helpers"),
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Brent-Tunnicliff/uuid-versions.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "SwiftJoke",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "EnumWrapper", package: "enum-wrapper-macro"),
                .product(name: "URLHelpers", package: "lib-url-macro-swift"),
                .product(name: "UUIDHelpers", package: "lib-url-macro-swift"),
                .product(name: "UUIDv5", package: "uuid-versions"),
            ],
            resources: [
                .process("Resources/Localizable.xcstrings")
            ]
        ),
        .testTarget(
            name: "SwiftJokeTests",
            dependencies: ["SwiftJoke"]
        ),
        .executableTarget(
            name: "joke",
            dependencies: [
                "SwiftJoke",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/JokeExecutable"
        ),
    ]
)

// MARK: - Common target settings

// Sets values that are common for every target.
// Plugins cannot contain plugins or swift settings.
for target in package.targets where target.type != .plugin {
    // MARK: Plugins

    let commonPlugins: [PackageDescription.Target.PluginUsage] = [
        .plugin(name: "LintBuildPlugin", package: "swift-format-plugin")
    ]

    target.plugins = (target.plugins ?? []) + commonPlugins

    // MARK: Swift compliler settings

    let commonSwiftSettings: [PackageDescription.SwiftSetting] = [
        // <https://docs.swift.org/latest/documentation/diagnostics/strict-memory-safety/>
        .strictMemorySafety(),

        // Upcoming swift features.
        // To see the list:
        //  - Run `xcrun swiftc -print-supported-features` to see the list of them.
        //  - Or visit <https://www.swift.org/swift-evolution/#?upcoming=true>
        // Details of each can be found at <https://github.com/swiftlang/swift-evolution>.

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md>
        .enableUpcomingFeature("ExistentialAny"),

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md>
        .enableUpcomingFeature("InternalImportsByDefault"),

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md>
        .enableUpcomingFeature("MemberImportVisibility"),

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md>
        .enableUpcomingFeature("InferIsolatedConformances"),

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md>
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),

        // <https://github.com/swiftlang/swift-evolution/blob/main/proposals/0481-weak-let.md>
        .enableUpcomingFeature("ImmutableWeakCaptures"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + commonSwiftSettings
}
