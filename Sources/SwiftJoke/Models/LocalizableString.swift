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
    case errorNetworkRequestFailed = "error_network_request_failed"
    case errorNetworkResponseWithErrorStatus = "error_network_response_with_error_status"
    case errorNoJokesMatchingRequestFilter = "error_no_jokes_matching_request_filter"
    case errorUnexpectedFailure = "error_unexpected_failure"
    case errorUnexpectedJokeSource = "error_unexpected_joke_source"
}

extension LocalizableString {
    func resolve() -> String {
        NSLocalizedString(rawValue, bundle: #bundle, comment: "")
    }
}
