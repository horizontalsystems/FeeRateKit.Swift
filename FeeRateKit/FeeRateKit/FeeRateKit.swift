import RxSwift

public class FeeRateKit {
    private let cache: IStorage
    private let providerManager: FeeRateProviderManager

    init(storage: IStorage, providerManager: FeeRateProviderManager) {
        self.cache = storage
        self.providerManager = providerManager
    }

    private func getRate(coin: Coin) -> Single<FeeRate> {
        providerManager.getFeeRateProvider(coin: coin).getFeeRates()
    }

}

extension FeeRateKit {

    public var bitcoin: Single<FeeRate> {
        getRate(coin: .bitcoin)
    }

    public var bitcoinCash: Single<FeeRate> {
        getRate(coin: .bitcoinCash)
    }

    public var dash: Single<FeeRate> {
        getRate(coin: .dash)
    }

    public var ethereum: Single<FeeRate> {
        getRate(coin: .ethereum)
    }

    public func getRate(coinCode: String) -> Single<FeeRate> {
        if let  coin = Coin(rawValue: coinCode) {
            return getRate(coin: coin)
        }

        return .error(FeeRateError.coinNotAvailable)
    }

}

extension FeeRateKit {

    public static func instance(providerConfig: FeeProviderConfig, minLogLevel: Logger.Level = .error) -> FeeRateKit {
        let logger = Logger(minLogLevel: minLogLevel)

        let cache: IStorage = FeeRateCache()
        let networkManager = NetworkManager(logger: logger)

        let feeRateProvider = FeeRateProviderManager(providerConfig: providerConfig, networkManager: networkManager, cache: cache)

        let kit = FeeRateKit(storage: cache, providerManager: feeRateProvider)

        return kit
    }

}
