// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

import EnumWrapper

// MARK: - JokeError.Code

extension JokeError {
    /// The error code representing what failed.
    @EnumWrapper
    enum Code: Int, CaseIterable, Codable, CustomDebugStringConvertible, CustomStringConvertible {
        /// An unexpected error occurred.
        case unexpectedFailure = -1001

        /// Network response returned an error status.
        case networkResponseErrorStatus = -1002

        /// Network request failed due to timing out.
        case networkRequestTimedOut = -1003

        /// Network request failed due to not being connected to internet.
        case notConnectedToInternet = -1004

        /// Network connection was severed in the middle of an in-progress load.
        case networkConnectionLost = -1005

        /// Network request failed for some other reason.
        case networkRequestFailed = -1006

        /// Decoding the payload failed, likely due to unexpected data structure.
        case decodingPayloadFailed = -1007
    }
}

// MARK: CustomDebugStringConvertible

extension JokeError.Code {
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        "\(self)"
    }
}

// MARK: CustomStringConvertible

extension JokeError.Code {
    /// A textual representation of this instance.
    public var description: String {
        rawValue.description
    }
}
