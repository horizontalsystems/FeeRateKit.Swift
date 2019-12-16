import RxSwift

protocol IStorage {
    func feeRate(coin: Coin) -> FeeRate?
    func save(feeRate: FeeRate)
}

protocol IFeeRateProvider {
    func getFeeRates() -> Single<FeeRate>
}
