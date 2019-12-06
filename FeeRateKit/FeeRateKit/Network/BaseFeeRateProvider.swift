import RxSwift

class BaseFeeRateProvider {
    private let coin: Coin
    private let feeRateProvider: IFeeRateProvider
    private let storage: IStorage

    init(coin: Coin, feeRateProvider: IFeeRateProvider, storage: IStorage) {
        self.coin = coin
        self.feeRateProvider = feeRateProvider
        self.storage = storage
    }

    private func provideFromCache() -> FeeRate? {
        guard let rate = storage.feeRate(coin: coin), Date().timeIntervalSince(rate.date) < coin.expirationTimeInterval else {
            return nil
        }

        return rate
    }

    private func provideFromFallback() -> FeeRate? {
        coin.defaultFeeRate
    }

}

extension BaseFeeRateProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        feeRateProvider.getFeeRates()
                .do(onSuccess: { [weak self] rate in
                    self?.storage.save(feeRate: rate)
                })
                .catchError { [weak self] error in
                    if let cachedRate = self?.provideFromCache() {
                        return .just(cachedRate)
                    }

                    if let fallBackRate = self?.provideFromFallback() {
                        return .just(fallBackRate)
                    }

                    return .error(error)
                }
    }

}
