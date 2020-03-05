import RxSwift

class BaseBtcProvider {
    private let coin: Coin
    private let networkManager: NetworkManager
    private let responseConverter: BaseBtcResponseConverter
    private let parametersProvider: IBtcParametersProvider
    private let baseUrl: String
    private let btcCoreRpcUser: String?
    private let btcCoreRpcPassword: String?

    init(coin: Coin, networkManager: NetworkManager, config: FeeProviderConfig, parametersProvider: IBtcParametersProvider, responseConverter: BaseBtcResponseConverter) {
        self.coin = coin
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

extension BaseBtcProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        let coin = self.coin
        return Single.zip(
                rateSingle(priority: .high),
                rateSingle(priority: .medium),
                rateSingle(priority: .low)
        ) { high, medium, low -> FeeRate in
            let defaultFeeRate = coin.defaultFeeRate

            return FeeRate(
                    coin: coin,
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
