import HsToolKit
import RxSwift

public class Kit {
    private let btcCoreProvider: BtcCoreProvider
    private let ethProvider: EvmProvider
    private let bscProvider: EvmProvider

    init(btcCoreProvider: BtcCoreProvider, ethProvider: EvmProvider, bscProvider: EvmProvider) {
        self.btcCoreProvider = btcCoreProvider
        self.ethProvider = ethProvider
        self.bscProvider = bscProvider
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
        ethProvider.getFeeRate()
    }

    public var binanceSmartChain: Single<Int> {
        bscProvider.getFeeRate()
    }

}

extension Kit {

    public static func instance(providerConfig: FeeProviderConfig, minLogLevel: Logger.Level = .error) -> Kit {
        let logger = Logger(minLogLevel: minLogLevel)

        let networkManager = NetworkManager(logger: logger)

        let btcCoreProvider = BtcCoreProvider(networkManager: networkManager, config: providerConfig)
        let ethProvider = EvmProvider(networkManager: networkManager, url: providerConfig.ethEvmUrl, auth: providerConfig.ethEvmAuth)
        let bscProvider = EvmProvider(networkManager: networkManager, url: providerConfig.bscEvmUrl)

        let kit = Kit(btcCoreProvider: btcCoreProvider, ethProvider: ethProvider, bscProvider: bscProvider)

        return kit
    }

}
