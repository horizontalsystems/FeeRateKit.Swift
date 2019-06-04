import GRDB

enum Coin: String, CaseIterable {
    case bitcoin = "BTC"
    case bitcoinCash = "BCH"
    case dash = "DASH"
    case ethereum = "ETH"

    var defaultFeeRate: FeeRate {
        switch self {
        case .bitcoin:      return FeeRate(coin: self, lowPriority: 20, mediumPriority: 40, highPriority: 80, date: Date(timeIntervalSince1970: 1543211299))
        case .bitcoinCash:  return FeeRate(coin: self, lowPriority: 1, mediumPriority: 3, highPriority: 5, date: Date(timeIntervalSince1970: 1543211299))
        case .dash:         return FeeRate(coin: self, lowPriority: 1, mediumPriority: 1, highPriority: 2, date: Date(timeIntervalSince1970: 1557224025))
        case .ethereum:     return FeeRate(coin: self, lowPriority: 13_000_000_000, mediumPriority: 16_000_000_000, highPriority: 19_000_000_000, date: Date(timeIntervalSince1970: 1543211299))
        }
    }

    var maxFee: Int {
        switch self {
        case .bitcoin:      return 5_000
        case .bitcoinCash:  return 500
        case .dash:         return 500
        case .ethereum:     return 3_000_000_000_000
        }
    }

    var minFee: Int {
        switch self {
        case .bitcoin:      return 1
        case .bitcoinCash:  return 1
        case .dash:         return 1
        case .ethereum:     return 100_000_000
        }
    }

}

extension Coin: DatabaseValueConvertible {

    public var databaseValue: DatabaseValue {
        return self.rawValue.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Coin? {
        if case let DatabaseValue.Storage.string(value) = dbValue.storage {
            return Coin(rawValue: value)
        }

        return nil
    }

}
