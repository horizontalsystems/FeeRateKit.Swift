import RxSwift

class FeeRateProviderManager {
    private let providerConfig: FeeProviderConfig
    private let networkManager: NetworkManager
    private let cache: IStorage

    private var providers = [Coin: IFeeRateProvider]()

    init(providerConfig: FeeProviderConfig, networkManager: NetworkManager, cache: IStorage) {
        self.providerConfig = providerConfig
        self.networkManager = networkManager
        self.cache = cache
    }

    func getFeeRateProvider(coin: Coin) -> IFeeRateProvider {
        providers[coin] ?? addProvider(coin: coin)
    }

    private func addProvider(coin: Coin) -> IFeeRateProvider {
        var feeRateProvider: IFeeRateProvider
        switch coin {
        case .bitcoin:
            feeRateProvider = BaseFeeRateProvider(coin: coin, feeRateProvider: BtcCoreProvider(networkManager: networkManager, baseUrl: providerConfig.btcCoreRpcUrl, btcCoreRpcUser: providerConfig.btcCoreRpcUser, btcCoreRpcPassword: providerConfig.btcCoreRpcPassword), storage: cache)
        case .ethereum:
            feeRateProvider = BaseFeeRateProvider(coin: coin, feeRateProvider: InfuraProvider(networkManager: networkManager, projectId: providerConfig.infuraProjectId, projectSecret: providerConfig.infuraProjectSecret), storage: cache)
        default:
            feeRateProvider = BaseFeeRateProvider(coin: coin, feeRateProvider: nil, storage: cache)
        }

        providers[coin] = feeRateProvider

        return feeRateProvider
    }

}
