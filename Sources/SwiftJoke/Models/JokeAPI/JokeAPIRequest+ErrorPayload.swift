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
            var userInfo: [String: String] = ["endpoint": JokeAPIRequest.source.description]

            #warning("TODO: map some error codes? like 106: 'No matching joke found'?")

            userInfo["internalError"] = internalError?.description
            userInfo["internalCode"] = code?.description
            userInfo["message"] = message
            userInfo["causedBy"] = causedBy.map(ListFormatter.localizedString(byJoining:))
            userInfo["additionalInfo"] = additionalInfo

            // Converting the timestamp to ISO8601 format.
            userInfo["timestamp"] = timestamp.map {
                let millisecondTimestamp = Double($0)
                let secondTimestamp = millisecondTimestamp / 1000.0
                let date = Date(timeIntervalSince1970: secondTimestamp)
                return ISO8601DateFormatter().string(from: date)
            }

            return JokeError(
                code: .networkResponseErrorStatus,
                localizedDescription: String(localized: .errorNetworkResponseWithErrorStatus),
                userInfo: userInfo
            )
        }
    }
}
