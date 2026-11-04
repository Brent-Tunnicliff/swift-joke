// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationInternationalization)
    import FoundationInternationalization
#else
    import Foundation
#endif

/// Used for resolving localizable strings.
///
/// We cannot use `String(localized:)` as it is currently only supported in Darwin platforms.
enum LocalizableString: String, CaseIterable {
    case errorDecodingPayloadFailed = "error_decoding_payload_failed"
    case errorNetworkConnectionLost = "error_network_connection_lost"
    case errorNetworkNotConnectedToInternet = "error_network_not_connected_to_internet"
    case errorNetworkRequestFailed = "error_network_request_failed"
    case errorNetworkRequestTimedOut = "error_network_request_timed_out"
    case errorNetworkResponseWithErrorStatus = "error_network_response_with_error_status"
    case errorUnexpectedFailure = "error_unexpected_failure"
}

extension LocalizableString {
    func resolve() -> String {
        NSLocalizedString(rawValue, bundle: #bundle, comment: "")
    }
}
