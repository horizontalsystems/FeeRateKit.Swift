import HsToolKit
import RxSwift

public class Kit {
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
        case .litecoin: return "Litecoin"
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

extension Kit {

    public var bitcoin: Single<FeeRate> {
        getRate(coin: .bitcoin)
    }

    public var litecoin: Single<FeeRate> {
        getRate(coin: .litecoin)
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
        let coins: [Coin] = [.bitcoin, .litecoin, .bitcoinCash, .dash, .ethereum]
        let tupleSingles: [Single<(String, Any)>] = coins.map(tupleSingle)
        return Single.zip(tupleSingles)
    }

}

extension Kit {

    public static func instance(providerConfig: FeeProviderConfig, minLogLevel: Logger.Level = .error) -> Kit {
        let logger = Logger(minLogLevel: minLogLevel)

        let cache: IStorage = FeeRateCache()
        let networkManager = NetworkManager(logger: logger)

        let feeRateProvider = FeeRateProviderManager(providerConfig: providerConfig, networkManager: networkManager, cache: cache)

        let kit = Kit(storage: cache, providerManager: feeRateProvider)

        return kit
    }

}
