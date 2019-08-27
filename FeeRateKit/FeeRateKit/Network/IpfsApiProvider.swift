import RxSwift

class IpfsApiProvider {
    private let networkManager: NetworkManager
    private let url: String
    private let timeoutInterval: TimeInterval

    init(networkManager: NetworkManager, baseUrl: String, timeoutInterval: TimeInterval) {
        self.networkManager = networkManager
        self.timeoutInterval = timeoutInterval

        url = "\(baseUrl)/ipns/QmXTJZBMMRmBbPun6HFt3tmb3tfYF2usLPxFoacL7G5uMX/blockchain/estimatefee/feerates.json"
    }

    func ratesSingle(coins: [Coin]) -> Single<[FeeRate]> {
        return networkManager.single(urlString: url, httpMethod: .get, parameters: [:], timoutInterval: timeoutInterval) { response -> [FeeRate]? in
            guard let map = response as? [String: Any] else {
                return nil
            }

            guard let timestamp = map["time"] as? Double else {
                return nil
            }

            guard let ratesMap = map["feerates"] as? [String: Any] else {
                return nil
            }

            let date = Date(timeIntervalSince1970: timestamp / 1000)
            var rates = [FeeRate]()

            for coin in coins {
                guard let valuesMap = ratesMap[coin.rawValue] as? [String: Any] else {
                    continue
                }

                guard let lowPriorityMap = valuesMap["low_priority"] as? [String: Any],
                      let lowPriorityRate = lowPriorityMap["rate"] as? Int,
                      let lowPriorityDuration = lowPriorityMap["duration"] as? Int else {
                    continue
                }
                guard let mediumPriorityMap = valuesMap["medium_priority"] as? [String: Any],
                      let mediumPriorityRate = mediumPriorityMap["rate"] as? Int,
                      let mediumPriorityDuration = mediumPriorityMap["duration"] as? Int else {
                    continue
                }
                guard let highPriorityMap = valuesMap["high_priority"] as? [String: Any],
                      let highPriorityRate = highPriorityMap["rate"] as? Int,
                      let highPriorityDuration = highPriorityMap["duration"] as? Int else {
                    continue
                }

                let feeRate = FeeRate(
                        coin: coin,
                        lowPriority: lowPriorityRate, mediumPriority: mediumPriorityRate, highPriority: highPriorityRate,
                        lowPriorityDuration: Double(lowPriorityDuration * 60),
                        mediumPriorityDuration: Double(mediumPriorityDuration * 60),
                        highPriorityDuration: Double(highPriorityDuration * 60),
                        date: date
                )

                rates.append(feeRate)
            }

            return rates
        }
    }

}
