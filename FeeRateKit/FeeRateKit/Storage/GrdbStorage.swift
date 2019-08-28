import GRDB

class GrdbStorage {
    private let dbPool: DatabasePool

    init() {
        let databaseURL = try! FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("FeeRateKit.sqlite")

        dbPool = try! DatabasePool(path: databaseURL.path)

        try! migrator.migrate(dbPool)
    }

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createFeeRates") { db in
            try db.create(table: FeeRate.databaseTableName) { t in
                t.column(FeeRate.Columns.coin.name, .text).notNull()
                t.column(FeeRate.Columns.lowPriority.name, .integer).notNull()
                t.column(FeeRate.Columns.mediumPriority.name, .integer).notNull()
                t.column(FeeRate.Columns.highPriority.name, .integer).notNull()
                t.column(FeeRate.Columns.date.name, .datetime).notNull()

                t.primaryKey([FeeRate.Columns.coin.name], onConflict: .replace)
            }
        }

        migrator.registerMigration("addFeeRateDurations") { db in
            try db.alter(table: FeeRate.databaseTableName) { t in
                t.add(column: FeeRate.Columns.lowPriorityDuration.name, .double).notNull().defaults(to: 0)
                t.add(column: FeeRate.Columns.mediumPriorityDuration.name, .double).notNull().defaults(to: 0)
                t.add(column: FeeRate.Columns.highPriorityDuration.name, .double).notNull().defaults(to: 0)
            }
        }

        return migrator
    }

}

extension GrdbStorage: IStorage {

    func feeRate(coin: Coin) -> FeeRate? {
        return try! dbPool.read { db in
            try FeeRate.filter(FeeRate.Columns.coin == coin).fetchOne(db)
        }
    }

    func save(feeRates: [FeeRate]) {
        _ = try? dbPool.write { db in
            for feeRate in feeRates {
                try feeRate.insert(db)
            }
        }
    }

}
