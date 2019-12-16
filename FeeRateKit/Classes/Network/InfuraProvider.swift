import RxSwift

class InfuraProvider {
    private let networkManager: NetworkManager
    private let url: String
    private var basicAuth: (user: String, password: String)?

    init(networkManager: NetworkManager, config: FeeProviderConfig) {
        self.networkManager = networkManager

        url = "https://mainnet.infura.io/v3/\(config.infuraProjectId)"
        basicAuth = config.infuraProjectSecret.map { (user: "", password: $0) }
    }

}

extension InfuraProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        let parameters: [String: Any] = [
            "id": "1",
            "jsonrpc": "2.0",
            "method": "eth_gasPrice",
            "params": []
        ]

        return networkManager.single(urlString: url, httpMethod: .post, basicAuth: basicAuth, parameters: parameters) { response -> FeeRate? in
            guard let map = response as? [String: Any] else {
                return nil
            }

            guard var hex = map["result"] as? String else {
                return nil
            }

            let prefix = "0x"

            if hex.hasPrefix(prefix) {
                hex = String(hex.dropFirst(prefix.count))
            }

            guard let fee = Int(hex, radix: 16) else {
                return nil
            }

            let defaultFeeRate = Coin.ethereum.defaultFeeRate

            return FeeRate(
                    coin: .ethereum,
                    lowPriority: fee / 2,
                    mediumPriority: fee,
                    highPriority: fee * 2,
                    lowPriorityDuration: defaultFeeRate.lowPriorityDuration,
                    mediumPriorityDuration: defaultFeeRate.mediumPriorityDuration,
                    highPriorityDuration: defaultFeeRate.highPriorityDuration,
                    date: Date()
            )
        }
    }

}
