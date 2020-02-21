import RxSwift

class BtcProvider {
    private let networkManager: NetworkManager
    private let responseConverter: BtcResponseConverter
    private let parametersProvider: IBtcParametersProvider
    private let baseUrl: String
    private let btcCoreRpcUser: String?
    private let btcCoreRpcPassword: String?

    init(networkManager: NetworkManager, config: FeeProviderConfig, parametersProvider: IBtcParametersProvider, responseConverter: BtcResponseConverter) {
        self.networkManager = networkManager
        self.parametersProvider = parametersProvider
        self.responseConverter = responseConverter
        self.baseUrl = config.btcCoreRpcUrl
        self.btcCoreRpcUser = config.btcCoreRpcUser
        self.btcCoreRpcPassword = config.btcCoreRpcPassword
    }

    private func rateSingle(priority: RequestPriority) -> Single<Int> {
        networkManager.single(urlString: parametersProvider.url(for: priority), httpMethod: .post, basicAuth: parametersProvider.auth, parameters: parametersProvider.parameters(for: priority)) { [weak self] response -> Int? in
            self?.responseConverter.convert(response: response)
        }
    }

}

extension BtcProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        Single.zip(
                rateSingle(priority: .high),
                rateSingle(priority: .medium),
                rateSingle(priority: .low)
        ) { high, medium, low -> FeeRate in
            let defaultFeeRate = Coin.bitcoin.defaultFeeRate

            return FeeRate(
                    coin: .bitcoin,
                    lowPriority: low,
                    mediumPriority: medium,
                    highPriority: high,
                    lowPriorityDuration: defaultFeeRate.lowPriorityDuration,
                    mediumPriorityDuration: defaultFeeRate.mediumPriorityDuration,
                    highPriorityDuration: defaultFeeRate.highPriorityDuration,
                    date: Date()
            )
        }
    }

}
