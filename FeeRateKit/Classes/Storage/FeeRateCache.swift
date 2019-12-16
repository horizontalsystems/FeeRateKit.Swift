class FeeRateCache {
    private var cache = [Coin: FeeRate]()
}

extension FeeRateCache: IStorage {

    func feeRate(coin: Coin) -> FeeRate? {
        cache[coin]
    }

    func save(feeRate: FeeRate) {
        cache[feeRate.coin] = feeRate
    }

}
