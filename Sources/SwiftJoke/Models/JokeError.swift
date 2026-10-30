// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    public import FoundationEssentials
#else
    public import Foundation
#endif

// MARK: - JokeError

/// Represents an error getting Jokes.
public struct JokeError {
    /// Code defining the type of error.
    public let code: CodeWrapper

    private let localizedDescription: String
    private let localizedFailureReason: String?
    private let userInfo: [String: String]

    public init(
        code: CodeWrapper,
        localizedDescription: String,
        localizedFailureReason: String?,
        userInfo: [String: String]
    ) {
        self.code = code
        self.localizedDescription = localizedDescription
        self.localizedFailureReason = localizedFailureReason
        self.userInfo = userInfo
    }

    public init(code: CodeWrapper, localizedDescription: String) {
        self.init(
            code: code,
            localizedDescription: localizedDescription,
            localizedFailureReason: nil,
            userInfo: [:]
        )
    }

    func with(localizedFailureReason: String) -> JokeError {
        JokeError(
            code: code,
            localizedDescription: localizedDescription,
            localizedFailureReason: localizedFailureReason,
            userInfo: userInfo
        )
    }

    func with(userInfo: [String: String]) -> JokeError {
        JokeError(
            code: code,
            localizedDescription: localizedDescription,
            localizedFailureReason: localizedFailureReason,
            userInfo: self.userInfo.merging(userInfo, uniquingKeysWith: { _, new in new })
        )
    }

    func with(error: any Error) -> JokeError {
        JokeError(
            code: code,
            localizedDescription: localizedDescription,
            localizedFailureReason: localizedFailureReason ?? error.localizedDescription,
            userInfo: self.userInfo.merging(
                ["caused_by": "\(error)"],
                uniquingKeysWith: { _, new in new }
            )
        )
    }
}

extension JokeError {
    #warning("TODO: Not to be included in the final product")
    @available(*, deprecated, message: "Not to be included in the final product")
    static let placeholder = JokeError(
        code: .unexpectedFailure,
        localizedDescription: "TODO: replace"
    )

    #warning("TODO: Address `String(localized:)` not existing in non-Darwin platforms.")
    /// Default case of the `networkResponseErrorStatus` error.
    public static let networkResponseErrorStatus = JokeError(
        code: .networkResponseErrorStatus,
        localizedDescription: String(localized: .errorNetworkResponseWithErrorStatus)
    )

    /// Default case of the `networkRequestTimedOut` error.
    public static let networkRequestTimedOut = JokeError(
        code: .networkRequestTimedOut,
        localizedDescription: String(localized: .errorNetworkRequestTimedOut)
    )

    /// Default case of the `notConnectedToInternet` error.
    public static let notConnectedToInternet = JokeError(
        code: .networkRequestTimedOut,
        localizedDescription: String(localized: .errorNotConnectedToInternet)
    )

    /// Default case of the `networkConnectionLost` error.
    public static let networkConnectionLost = JokeError(
        code: .networkConnectionLost,
        localizedDescription: String(localized: .errorNetworkConnectionLost)
    )

    /// Default case of the `networkRequestFailed` error.
    public static let networkRequestFailed = JokeError(
        code: .networkRequestFailed,
        localizedDescription: String(localized: .errorNetworkRequestFailed)
    )

    /// Default case of the `unexpectedFailure` error.
    public static let unexpectedFailure = JokeError(
        code: .unexpectedFailure,
        localizedDescription: String(localized: .errorUnexpectedFailure)
    )

    /// Default case of the `decodingPayloadFailed` error.
    public static let decodingPayloadFailed = JokeError(
        code: .decodingPayloadFailed,
        localizedDescription: String(localized: .errorDecodingPayloadFailed)
    )

    /// Returns a Boolean value indicating whether the two errors are of the same domain and code.
    public static func ~= (pattern: JokeError, value: some Error) -> Bool {
        guard let value = value as? JokeError else {
            return false
        }

        return pattern.code == value.code
    }
}

// MARK: Codable

extension JokeError: Codable {}

// MARK: CustomDebugStringConvertible

extension JokeError: CustomDebugStringConvertible {
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        "\(Self.errorDomain).\(code.debugDescription) (\(code.description))"
    }
}

// MARK: CustomNSError

extension JokeError: CustomNSError {
    /// The domain of the error.
    public static let errorDomain: String = "SwiftJoke.Error"

    /// The error code within the given domain.
    public var errorCode: Int {
        code.rawValue
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        userInfo
    }
}

// MARK: CustomStringConvertible

extension JokeError: CustomStringConvertible {
    /// A textual representation of this instance.
    public var description: String {
        "\(Self.errorDomain) (\(code.description))"
    }
}

// MARK: Hashable

extension JokeError: Hashable {}

// MARK: LocalizedError

extension JokeError: LocalizedError {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        localizedDescription
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        localizedFailureReason
    }
}

// MARK: Sendable

extension JokeError: Sendable {}
