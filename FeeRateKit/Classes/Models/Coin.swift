enum Coin: String, CaseIterable {
    case bitcoin = "BTC"
    case litecoin = "LTC"
    case bitcoinCash = "BCH"
    case dash = "DASH"
    case ethereum = "ETH"

    var defaultFeeRate: FeeRate {
        switch self {
        case .bitcoin:
            return FeeRate(
                coin: self,
                lowPriority: 20,
                mediumPriority: 40,
                highPriority: 80,
                lowPriorityDuration: 600 * 60,
                mediumPriorityDuration: 120 * 60,
                highPriorityDuration: 30 * 60,
                date: Date()
            )
        case .litecoin:
            return FeeRate(
                    coin: self,
                    lowPriority: 1,
                    mediumPriority: 2,
                    highPriority: 4,
                    lowPriorityDuration: 30 * 60,
                    mediumPriorityDuration: 15 * 60,
                    highPriorityDuration: 3 * 60,
                    date: Date()
            )
        case .bitcoinCash:
            return FeeRate(
                    coin: self,
                    lowPriority: 1,
                    mediumPriority: 3,
                    highPriority: 5,
                    lowPriorityDuration: 240 * 60,
                    mediumPriorityDuration: 120 * 60,
                    highPriorityDuration: 30 * 60,
                    date: Date()
            )
        case .dash:
            return FeeRate(
                    coin: self,
                    lowPriority: 1,
                    mediumPriority: 1,
                    highPriority: 2,
                    lowPriorityDuration: 1,
                    mediumPriorityDuration: 1,
                    highPriorityDuration: 1,
                    date: Date())
        case .ethereum:
            return FeeRate(
                    coin: self,
                    lowPriority: 13_000_000_000,
                    mediumPriority: 16_000_000_000,
                    highPriority: 19_000_000_000,
                    lowPriorityDuration: 30 * 60,
                    mediumPriorityDuration: 5 * 60,
                    highPriorityDuration: 2 * 60,
                    date: Date()
            )
        }
    }

    var maxFee: Int {
        switch self {
        case .bitcoin:      return 5_000
        case .litecoin:     return 5_000
        case .bitcoinCash:  return 500
        case .dash:         return 500
        case .ethereum:     return 3_000_000_000_000
        }
    }

    var minFee: Int {
        switch self {
        case .bitcoin:      return 1
        case .litecoin:     return 1
        case .bitcoinCash:  return 1
        case .dash:         return 1
        case .ethereum:     return 100_000_000
        }
    }

    var expirationTimeInterval: TimeInterval {
        switch self {
        case .bitcoin:      return 6 * 60
        case .litecoin:     return 6 * 60
        case .bitcoinCash:  return 0
        case .dash:         return 0
        case .ethereum:     return 3 * 60
        }
    }

}
