import GRDB

enum Coin: String, CaseIterable {
    case bitcoin = "BTC"
    case bitcoinCash = "BCH"
    case ethereum = "ETH"

    var defaultFeeRate: FeeRate {
        switch self {
        case .bitcoin:      return FeeRate(coin: self, lowPriority: 20, mediumPriority: 40, highPriority: 80, date: Date(timeIntervalSince1970: 1543211299))
        case .bitcoinCash:  return FeeRate(coin: self, lowPriority: 1, mediumPriority: 3, highPriority: 5, date: Date(timeIntervalSince1970: 1543211299))
        case .ethereum:     return FeeRate(coin: self, lowPriority: 13, mediumPriority: 16, highPriority: 19, date: Date(timeIntervalSince1970: 1543211299))
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
