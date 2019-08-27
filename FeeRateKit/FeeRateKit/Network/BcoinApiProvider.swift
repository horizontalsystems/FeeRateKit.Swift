import RxSwift

class BcoinApiProvider {
    private let networkManager: NetworkManager
    private let baseUrl: String

    init(networkManager: NetworkManager, baseUrl: String) {
        self.networkManager = networkManager
        self.baseUrl = baseUrl
    }

    func bitcoinRateSingle() -> Single<FeeRate> {
        return Single.zip(
                rateSingle(numberOfBlocks: 1),
                rateSingle(numberOfBlocks: 6),
                rateSingle(numberOfBlocks: 15)
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

    private func rateSingle(numberOfBlocks: Int) -> Single<Int> {
        let parameters: [String: Any] = [
            "method": "estimatesmartfee",
            "params": [numberOfBlocks]
        ]

        return networkManager.single(urlString: baseUrl, httpMethod: .post, parameters: parameters) { response -> Int? in
            guard let map = response as? [String: Any] else {
                return nil
            }

            guard let result = map["result"] as? [String: Any] else {
                return nil
            }

            guard let fee = result["fee"] as? Double else {
                return nil
            }

            guard fee > 0 else {
                return nil
            }

            return Int(fee * 100_000_000 / 1024)
        }
    }

}
