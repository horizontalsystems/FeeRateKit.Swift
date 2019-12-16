import RxSwift

class DefaultProvider {
    private let coin: Coin

    init(coin: Coin) {
        self.coin = coin
    }

}

extension DefaultProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        .just(coin.defaultFeeRate)
    }

}
