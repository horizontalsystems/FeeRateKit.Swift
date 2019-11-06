class FeeRateCache {
    private var cache = [Coin: FeeRate]()
}

extension FeeRateCache: IStorage {

    func feeRate(coin: Coin) -> FeeRate? {
        guard let rate = cache[coin], Date().timeIntervalSince(rate.date) < coin.expirationTimeInterval else {
            return nil
        }

        return rate
    }

    func save(feeRate: FeeRate) {
        cache[feeRate.coin] = feeRate
    }

}
