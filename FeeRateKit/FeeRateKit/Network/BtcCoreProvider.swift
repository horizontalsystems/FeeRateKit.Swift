import RxSwift

class BtcCoreProvider {
    private let networkManager: NetworkManager
    private let baseUrl: String
    private let btcCoreRpcUser: String?
    private let btcCoreRpcPassword: String?

    init(networkManager: NetworkManager, baseUrl: String, btcCoreRpcUser: String?, btcCoreRpcPassword: String?) {
        self.networkManager = networkManager
        self.baseUrl = baseUrl
        self.btcCoreRpcUser = btcCoreRpcUser
        self.btcCoreRpcPassword = btcCoreRpcPassword
    }

    private func rateSingle(numberOfBlocks: Int) -> Single<Int> {
        let parameters: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "estimatesmartfee",
            "params": [numberOfBlocks],
            "id": 1
        ]

        var auth: (String, String)? = nil
        if let user = btcCoreRpcUser, let password = btcCoreRpcPassword {
            auth = (user, password)
        }

        return networkManager.single(urlString: baseUrl, httpMethod: .post, basicAuth: auth, parameters: parameters) { response -> Int? in
            guard let map = response as? [String: Any] else {
                return nil
            }

            guard let result = map["result"] as? [String: Any] else {
                return nil
            }

            guard let fee = (result["fee"] as? Double) ?? (result["feerate"] as? Double) else {
                return nil
            }

            guard fee > 0 else {
                return nil
            }

            return Int(fee * 100_000_000 / 1024)
        }
    }

}

extension BtcCoreProvider: IFeeRateProvider {

    func getFeeRates() -> Single<FeeRate> {
        Single.zip(
                rateSingle(numberOfBlocks: 1),
                rateSingle(numberOfBlocks: 5),
                rateSingle(numberOfBlocks: 10)
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
