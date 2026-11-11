// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials) && canImport(FoundationNetworking)
    public import FoundationEssentials
    import FoundationNetworking
#else
    public import Foundation
#endif

// MARK: - JokeError

/// Represents an error getting Jokes.
public struct JokeError {
    /// The domain of the error.
    public static let errorDomain: String = "SwiftJoke.Error"

    /// Code defining the type of error.
    public let code: CodeWrapper

    private let localizedDescription: String
    private let localizedFailureReason: String?
    private let userInfo: [String: String]

    /// Initialise an instance of the error.
    public init(
        code: CodeWrapper,
        localizedDescription: String,
        localizedFailureReason: String? = nil,
        userInfo: [String: String] = [:]
    ) {
        self.code = code
        self.localizedDescription = localizedDescription
        self.localizedFailureReason = localizedFailureReason
        self.userInfo = userInfo
    }

    init(code: CodeWrapper, localizedDescription: LocalizableString) {
        self.init(
            code: code,
            localizedDescription: localizedDescription.resolve(),
            localizedFailureReason: nil,
            userInfo: [:]
        )
    }

    init(code: CodeWrapper, urlError: URLError.Code) {
        self.init(
            code: code,
            localizedDescription: URLError(urlError).localizedDescription,
            localizedFailureReason: nil,
            userInfo: [:]
        )
    }

    func with(localizedFailureReason: String?) -> JokeError {
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
                [UserInfoKey.causedBy: "\(error)"],
                uniquingKeysWith: { _, new in new }
            )
        )
    }
}

extension JokeError {
    /// Default case of the `networkResponseErrorStatus` error.
    public static let networkResponseErrorStatus = JokeError(
        code: .networkResponseErrorStatus,
        localizedDescription: .errorNetworkResponseWithErrorStatus
    )

    /// Default case of the `networkRequestTimedOut` error.
    public static let networkRequestTimedOut = JokeError(
        code: .networkRequestTimedOut,
        urlError: .timedOut
    )

    /// Default case of the `notConnectedToInternet` error.
    public static let notConnectedToInternet = JokeError(
        code: .networkRequestTimedOut,
        urlError: .notConnectedToInternet
    )

    /// Default case of the `networkConnectionLost` error.
    public static let networkConnectionLost = JokeError(
        code: .networkConnectionLost,
        urlError: .networkConnectionLost
    )

    /// Default case of the `networkRequestFailed` error.
    public static let networkRequestFailed = JokeError(
        code: .networkRequestFailed,
        localizedDescription: .errorNetworkRequestFailed
    )

    /// Default case of the `unexpectedFailure` error.
    public static let unexpectedFailure = JokeError(
        code: .unexpectedFailure,
        localizedDescription: .errorUnexpectedFailure
    )

    /// Default case of the `decodingPayloadFailed` error.
    public static let decodingPayloadFailed = JokeError(
        code: .decodingPayloadFailed,
        localizedDescription: .errorDecodingPayloadFailed
    )

    /// Default case of the `noJokesMatchingRequestFilter` error.
    public static let noJokesMatchingRequestFilter = JokeError(
        code: .noJokesMatchingRequestFilter,
        localizedDescription: .errorNoJokesMatchingRequestFilter
    )

    /// Default case of the `unexpectedJokeSource` error.
    public static let unexpectedJokeSource = JokeError(
        code: .unexpectedJokeSource,
        localizedDescription: .errorUnexpectedJokeSource
    )
}

extension JokeError {
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

#if canImport(ObjectiveC)
    // MARK: CustomNSError

    extension JokeError: CustomNSError {
        /// The error code within the given domain.
        public var errorCode: Int {
            code.rawValue
        }

        /// The user-info dictionary.
        public var errorUserInfo: [String: Any] {
            userInfo
        }
    }
#endif

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

// MARK: - UserInfoKey

extension JokeError {
    enum UserInfoKey {
        static let additionalInfo = "additional_info"
        static let causedBy = "caused_by"
        static let endpoint = "endpoint"
        static let internalError = "internal_error"
        static let internalCode = "internal_code"
        static let message = "message"
        static let status = "status"
        static let timestamp = "timestamp"
    }
}
