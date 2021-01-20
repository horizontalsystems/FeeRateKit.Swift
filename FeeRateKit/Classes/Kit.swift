import HsToolKit
import RxSwift

public class Kit {
    private let btcCoreProvider: BtcCoreProvider
    private let infuraProvider: InfuraProvider

    init(btcCoreProvider: BtcCoreProvider, infuraProvider: InfuraProvider) {
        self.btcCoreProvider = btcCoreProvider
        self.infuraProvider = infuraProvider
    }

}

extension Kit {

    public func bitcoin(blockCount: Int) -> Single<Int> {
        btcCoreProvider.getFeeRate(blockCount: blockCount)
    }

    public var litecoin: Single<Int> {
        Single.just(1)
    }

    public var bitcoinCash: Single<Int> {
        Single.just(3)
    }

    public var dash: Single<Int> {
        Single.just(4)
    }

    public var ethereum: Single<Int> {
        infuraProvider.getFeeRate()
    }

}

extension Kit {

    public static func instance(providerConfig: FeeProviderConfig, minLogLevel: Logger.Level = .error) -> Kit {
        let logger = Logger(minLogLevel: minLogLevel)

        let networkManager = NetworkManager(logger: logger)

        let btcCoreProvider = BtcCoreProvider(networkManager: networkManager, config: providerConfig)
        let infuraProvider = InfuraProvider(networkManager: networkManager, config: providerConfig)

        let kit = Kit(btcCoreProvider: btcCoreProvider, infuraProvider: infuraProvider)

        return kit
    }

}
