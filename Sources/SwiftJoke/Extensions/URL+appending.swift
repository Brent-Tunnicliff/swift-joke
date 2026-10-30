// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

#if canImport(FoundationNetworking)
    import FoundationNetworking
#else
    import Foundation
#endif

extension URL {
    func appending<S>(components: [S]) -> URL where S: StringProtocol {
        guard !components.isEmpty else {
            return self
        }

        var result = self
        for component in components {
            result.append(path: component)
        }
        return result
    }
}
