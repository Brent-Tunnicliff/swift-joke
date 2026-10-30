// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

/// Configuration for requesting jokes from any source.
///
/// Only supports customising request by amount, if want to customise further use the specific sources directly.
public struct AnyRequest {
    /// The maximum amount of jokes to request at once.
    public let amount: UInt8
}
