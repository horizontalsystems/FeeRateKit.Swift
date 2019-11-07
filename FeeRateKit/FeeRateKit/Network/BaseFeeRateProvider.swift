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

    private func provideFromFallback() -> FeeRate? {
        guard let rate = storage.feeRate(coin: coin), Date().timeIntervalSince(rate.date) < coin.expirationTimeInterval else {
            return nil
        }

        return rate
    }

}

extension BaseFeeRateProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        feeRateProvider.getFeeRates()
                .do(onSuccess: { [weak self] rate in
                    self?.storage.save(feeRate: rate)
                })
                .catchError { [weak self] error in
                    guard let fallBackRate = self?.provideFromFallback() else {
                        return .error(error)
                    }

                    return .just(fallBackRate)
                }
    }

}
