import HsToolKit

public class Kit {
    private let mempoolSpaceProvider: MempoolSpaceProvider
    private let ethProvider: EvmProvider
    private let bscProvider: EvmProvider

    init(mempoolSpaceProvider: MempoolSpaceProvider, ethProvider: EvmProvider, bscProvider: EvmProvider) {
        self.mempoolSpaceProvider = mempoolSpaceProvider
        self.ethProvider = ethProvider
        self.bscProvider = bscProvider
    }

}

extension Kit {

    public func bitcoin() async throws -> MempoolSpaceProvider.RecommendedFees {
        try await mempoolSpaceProvider.getFeeRate()
    }

    public var litecoin: Int {
        3
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

        let mempoolSpaceProvider = MempoolSpaceProvider(networkManager: networkManager, config: providerConfig)
        let ethProvider = EvmProvider(networkManager: networkManager, url: providerConfig.ethEvmUrl, auth: providerConfig.ethEvmAuth)
        let bscProvider = EvmProvider(networkManager: networkManager, url: providerConfig.bscEvmUrl)

        let kit = Kit(mempoolSpaceProvider: mempoolSpaceProvider, ethProvider: ethProvider, bscProvider: bscProvider)

        return kit
    }

}
