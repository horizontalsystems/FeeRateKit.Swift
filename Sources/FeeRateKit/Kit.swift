import HsToolKit

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

    public func bitcoin(blockCount: Int) async throws -> Int {
        try await btcCoreProvider.getFeeRate(blockCount: blockCount)
    }

    public var litecoin: Int {
        1
    }

    public var bitcoinCash: Int {
        3
    }

    public var dash: Int {
        4
    }

    public func ethereum() async throws -> Int {
        try await ethProvider.getFeeRate()
    }

    public func binanceSmartChain() async throws -> Int {
        try await bscProvider.getFeeRate()
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
