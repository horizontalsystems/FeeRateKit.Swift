import RxSwift

class BaseFeeRateProvider {
    private let coin: Coin
    private let feeRateProvider: IFeeRateProvider?
    private let storage: IStorage

    init(coin: Coin, feeRateProvider: IFeeRateProvider?, storage: IStorage) {
        self.coin = coin
        self.feeRateProvider = feeRateProvider
        self.storage = storage
    }

    private func provideFromFallBack() -> FeeRate? {
        storage.feeRate(coin: coin)
    }

}

extension BaseFeeRateProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        feeRateProvider?.getFeeRates()
                .do(onSuccess: { [weak self] rate in
                    self?.storage.save(feeRate: rate)
                })
                .catchError { [weak self] error in
                    guard let fallBackRate = self?.provideFromFallBack() else {
                        return .error(error)
                    }

                    return .just(fallBackRate)
                } ?? .just(coin.defaultFeeRate)
    }

}
