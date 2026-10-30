// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationNetworking)
    import FoundationNetworking
#else
    import Foundation
#endif

extension HTTPURLResponse {
    static let successStatusCodes = 200..<300
    static let clientErrorStatusCodes = 400..<500
    static let serverErrorStatusCodes = 500..<600

    var statusCodeIsSuccess: Bool {
        Self.successStatusCodes.contains(statusCode)
    }

    var statusCodeIsClientError: Bool {
        Self.clientErrorStatusCodes.contains(statusCode)
    }

    var statusCodeIsServerError: Bool {
        Self.serverErrorStatusCodes.contains(statusCode)
    }
}
