// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationNetworking)
    import FoundationNetworking
#else
    import Foundation
#endif

enum JokeRequestMethod: Hashable, Sendable {
    case network(URLRequest)
}
