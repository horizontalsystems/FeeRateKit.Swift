import GRDB

public class FeeRate: Record {
    private let coin: Coin
    private let lowPriority: Int
    private let mediumPriority: Int
    private let highPriority: Int
    public let date: Date

    public var low: Int {
        return min(lowPriority, coin.maxFee)
    }

    public var medium: Int {
        return min(mediumPriority, coin.maxFee)
    }

    public var high: Int {
        return min(highPriority, coin.maxFee)
    }

    init(coin: Coin, lowPriority: Int, mediumPriority: Int, highPriority: Int, date: Date) {
        self.coin = coin
        self.lowPriority = lowPriority
        self.mediumPriority = mediumPriority
        self.highPriority = highPriority
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
        case date
    }

    required init(row: Row) {
        coin = row[Columns.coin]
        lowPriority = row[Columns.lowPriority]
        mediumPriority = row[Columns.mediumPriority]
        highPriority = row[Columns.highPriority]
        date = row[Columns.date]

        super.init(row: row)
    }

    override public func encode(to container: inout PersistenceContainer) {
        container[Columns.coin] = coin
        container[Columns.lowPriority] = lowPriority
        container[Columns.mediumPriority] = mediumPriority
        container[Columns.highPriority] = highPriority
        container[Columns.date] = date
    }

}

extension FeeRate: CustomStringConvertible {

    public var description: String {
        return "FeeRate [coin: \(coin), low: \(lowPriority), medium: \(mediumPriority), high: \(highPriority), date: \(date)]"
    }

}
