// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationEssentials)
    import FoundationEssentials
#else
    import Foundation
#endif

extension JokeAPIRequest {
    struct ErrorPayload: Decodable {
        let internalError: Bool?
        // Internal API error code seperate from general HTTP response status code.
        let code: Int?
        let message: String?
        let causedBy: [String]?
        let additionalInfo: String?
        let timestamp: Int?

        func asJokeError() -> JokeError {
            var userInfo: [String: String] = [JokeError.UserInfoKey.endpoint: JokeAPIRequest.source.description]
            userInfo[JokeError.UserInfoKey.internalError] = internalError?.description
            userInfo[JokeError.UserInfoKey.internalCode] = code?.description
            userInfo[JokeError.UserInfoKey.message] = message
            userInfo[JokeError.UserInfoKey.causedBy] = causedBy.map(ListFormatter.localizedString(byJoining:))
            userInfo[JokeError.UserInfoKey.additionalInfo] = additionalInfo

            // Converting the timestamp to ISO8601 format.
            userInfo[JokeError.UserInfoKey.timestamp] = timestamp.map {
                let millisecondTimestamp = Double($0)
                let secondTimestamp = millisecondTimestamp / 1000.0
                let date = Date(timeIntervalSince1970: secondTimestamp)
                return ISO8601DateFormatter().string(from: date)
            }

            let baseError: JokeError =
                switch self.code {
                case 106: .noJokesMatchingRequestFilter
                default: .networkResponseErrorStatus
                }

            return baseError.with(localizedFailureReason: message)
                .with(userInfo: userInfo)
        }
    }
}
