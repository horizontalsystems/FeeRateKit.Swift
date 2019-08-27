import GRDB

public class FeeRate: Record {
    private let coin: Coin
    private let lowPriority: Int
    private let mediumPriority: Int
    private let highPriority: Int
    public let lowPriorityDuration: TimeInterval
    public let mediumPriorityDuration: TimeInterval
    public let highPriorityDuration: TimeInterval
    public let date: Date

    public var low: Int {
        return max(min(lowPriority, coin.maxFee), coin.minFee)
    }

    public var medium: Int {
        return max(min(mediumPriority, coin.maxFee), coin.minFee)
    }

    public var high: Int {
        return max(min(highPriority, coin.maxFee), coin.minFee)
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

        super.init()
    }

    override public class var databaseTableName: String {
        return "fee_rates"
    }

    enum Columns: String, ColumnExpression {
        case coin
        case lowPriority
        case mediumPriority
        case highPriority
        case lowPriorityDuration
        case mediumPriorityDuration
        case highPriorityDuration
        case date
    }

    required init(row: Row) {
        coin = row[Columns.coin]
        lowPriority = row[Columns.lowPriority]
        mediumPriority = row[Columns.mediumPriority]
        highPriority = row[Columns.highPriority]
        lowPriorityDuration = row[Columns.lowPriorityDuration]
        mediumPriorityDuration = row[Columns.mediumPriorityDuration]
        highPriorityDuration = row[Columns.highPriorityDuration]
        date = row[Columns.date]

        super.init(row: row)
    }

    override public func encode(to container: inout PersistenceContainer) {
        container[Columns.coin] = coin
        container[Columns.lowPriority] = lowPriority
        container[Columns.mediumPriority] = mediumPriority
        container[Columns.highPriority] = highPriority
        container[Columns.lowPriorityDuration] = lowPriorityDuration
        container[Columns.mediumPriorityDuration] = mediumPriorityDuration
        container[Columns.highPriorityDuration] = highPriorityDuration
        container[Columns.date] = date
    }

}

extension FeeRate: CustomStringConvertible {

    public var description: String {
        return "FeeRate [coin: \(coin), low: \(lowPriority), medium: \(mediumPriority), high: \(highPriority)" + 
        ", lowDuration: \(lowPriorityDuration), mediumDuration: \(mediumPriorityDuration), highDuration: \(highPriorityDuration), date: \(date)]"
    }

}
