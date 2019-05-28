import RxSwift

class IpfsApiProvider {
    private let networkManager: NetworkManager
    private let url: String
    private let timeoutInterval: TimeInterval

    init(networkManager: NetworkManager, baseUrl: String, timeoutInterval: TimeInterval) {
        self.networkManager = networkManager
        self.timeoutInterval = timeoutInterval

        url = "\(baseUrl)/ipns/QmXTJZBMMRmBbPun6HFt3tmb3tfYF2usLPxFoacL7G5uMX/blockchain/estimatefee/index.json"
    }

    func ratesSingle(coins: [Coin]) -> Single<[FeeRate]> {
        return networkManager.single(urlString: url, httpMethod: .get, parameters: [:], timoutInterval: timeoutInterval) { response -> [FeeRate]? in
            guard let map = response as? [String: Any] else {
                return nil
            }

            guard let timestamp = map["time"] as? Double else {
                return nil
            }

            guard let ratesMap = map["rates"] as? [String: Any] else {
                return nil
            }

            let date = Date(timeIntervalSince1970: timestamp / 1000)
            var rates = [FeeRate]()

            for coin in coins {
                guard let valuesMap = ratesMap[coin.rawValue] as? [String: Int] else {
                    continue
                }

                guard let lowPriority = valuesMap["low_priority"] else {
                    continue
                }
                guard let mediumPriority = valuesMap["medium_priority"] else {
                    continue
                }
                guard let highPriority = valuesMap["high_priority"] else {
                    continue
                }

                rates.append(FeeRate(coin: coin, lowPriority: lowPriority, mediumPriority: mediumPriority, highPriority: highPriority, date: date))
            }

            return rates
        }
    }

}
