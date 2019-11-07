public class FeeRate {
    let coin: Coin
    private let lowPriority: Int
    private let mediumPriority: Int
    private let highPriority: Int
    public let lowPriorityDuration: TimeInterval
    public let mediumPriorityDuration: TimeInterval
    public let highPriorityDuration: TimeInterval
    public let date: Date

    public var low: Int {
        max(min(lowPriority, coin.maxFee), coin.minFee)
    }

    public var medium: Int {
        max(min(mediumPriority, coin.maxFee), coin.minFee)
    }

    public var high: Int {
        max(min(highPriority, coin.maxFee), coin.minFee)
    }

    init(coin: Coin, lowPriority: Int, mediumPriority: Int, highPriority: Int,
         lowPriorityDuration: TimeInterval, mediumPriorityDuration: TimeInterval, highPriorityDuration: TimeInterval, date: Date) {
        self.coin = coin
        self.lowPriority = lowPriority
        self.mediumPriority = mediumPriority
        self.highPriority = highPriority
        self.lowPriorityDuration = lowPriorityDuration
        self.mediumPriorityDuration = mediumPriorityDuration
        self.highPriorityDuration = highPriorityDuration
        self.date = date
    }

}

extension FeeRate: CustomStringConvertible {

    public var description: String {
        "FeeRate [coin: \(coin), low: \(lowPriority), medium: \(mediumPriority), high: \(highPriority)" + 
        ", lowDuration: \(lowPriorityDuration), mediumDuration: \(mediumPriorityDuration), highDuration: \(highPriorityDuration), date: \(date)]"
    }

}
