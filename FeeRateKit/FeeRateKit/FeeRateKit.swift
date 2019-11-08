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

    private func name(from coin: Coin) -> String {
        switch coin {
        case .bitcoin: return "Bitcoin"
        case .bitcoinCash: return "Bitcoin Cash"
        case .dash: return "Dash"
        case .ethereum: return "Ethereum"
        }
    }

    private func tupleSingle(from coin: Coin) -> Single<(String, Any)> {
        getRate(coin: coin)
                .flatMap { [unowned self] rate -> Single<(String, Any)> in
                    .just((self.name(from: coin), [
                        ("low", rate.low),
                        ("medium", rate.medium),
                        ("high", rate.high),
                        ("date", rate.date)
                    ]))
                }
                .catchError { [unowned self] error in
                    .just(("\(self.name(from: coin)) error", error.localizedDescription))
                }
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

    public func statusInfo() -> Single<[(String, Any)]> {
        let coins: [Coin] = [.bitcoin, .bitcoinCash, .dash, .ethereum]
        let tupleSingles: [Single<(String, Any)>] = coins.map(tupleSingle)
        return Single.zip(tupleSingles)
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
