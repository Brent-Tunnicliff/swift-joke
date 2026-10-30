// Copyright © 2026 Brent Tunnicliff <brent@tunnicliff.dev>

// MARK: - AmountWrapper

extension OfficialJokeAPIRequest {
    public struct AmountWrapper: Codable, Hashable, Sendable {
        let wrappedValue: OfficialJokeAPIRequest.Amount
    }
}

extension OfficialJokeAPIRequest.AmountWrapper {
    public static func flexible(_ count: UInt8) -> OfficialJokeAPIRequest.AmountWrapper {
        OfficialJokeAPIRequest.AmountWrapper(wrappedValue: .flexible(count))
    }

    public static func hardcoded(
        _ count: OfficialJokeAPIRequest.HardcodedAmountWrapper
    ) -> OfficialJokeAPIRequest.AmountWrapper {
        OfficialJokeAPIRequest.AmountWrapper(wrappedValue: .hardcoded(count))
    }
}

extension OfficialJokeAPIRequest.AmountWrapper {
    var asHardcodedAmount: OfficialJokeAPIRequest.HardcodedAmountWrapper? {
        switch wrappedValue {
        case .flexible: nil
        case let .hardcoded(value): value
        }
    }

    var asUInt8: UInt8 {
        switch wrappedValue {
        case let .flexible(value): value
        case let .hardcoded(value): value.rawValue
        }
    }
}

extension OfficialJokeAPIRequest.AmountWrapper: RawRepresentable {
    public var rawValue: UInt8 {
        wrappedValue.rawValue
    }

    public init(rawValue: UInt8) {
        self.init(
            wrappedValue: OfficialJokeAPIRequest.Amount(rawValue: rawValue)
        )
    }
}

// MARK: - Amount

extension OfficialJokeAPIRequest {
    enum Amount: Codable, Hashable, Sendable {
        case flexible(UInt8)
        case hardcoded(OfficialJokeAPIRequest.HardcodedAmountWrapper)
    }
}

extension OfficialJokeAPIRequest.Amount: RawRepresentable {
    var rawValue: UInt8 {
        switch self {
        case let .flexible(value): value
        case let .hardcoded(hardcodedAmount): hardcodedAmount.rawValue
        }
    }

    init(rawValue: UInt8) {
        self = .flexible(rawValue)
    }
}
