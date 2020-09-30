import Alamofire
import RxSwift
import HsToolKit

class BaseBtcProvider {
    private let coin: Coin
    private let networkManager: NetworkManager
    private let parametersProvider: IBtcParametersProvider

    init(coin: Coin, networkManager: NetworkManager, parametersProvider: IBtcParametersProvider) {
        self.coin = coin
        self.networkManager = networkManager
        self.parametersProvider = parametersProvider
    }

    private func rateSingle(priority: RequestPriority) -> Single<Int> {
        var headers = HTTPHeaders()

        if let auth = parametersProvider.auth {
            headers.add(.authorization(username: auth.0, password: auth.1))
        }

        let request = networkManager.session.request(parametersProvider.url(for: priority), method: .post, parameters: parametersProvider.parameters(for: priority), headers: headers)

        return networkManager.single(request: request, mapper: self)
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

extension BaseBtcProvider: IApiMapper {

    enum ResponseError: Error {
        case noResult
        case noFeeRate
        case feeIsZero
    }

    func map(statusCode: Int, data: Any?) throws -> Int {
        guard let map = data as? [String: Any] else {
            throw NetworkManager.RequestError.invalidResponse(statusCode: statusCode, data: data)
        }

        guard let result = map["result"] as? [String: Any] else {
            throw ResponseError.noResult
        }

        guard let fee = (result["fee"] as? Double) ?? (result["feerate"] as? Double) else {
            throw ResponseError.noFeeRate
        }

        guard fee > 0 else {
            throw ResponseError.feeIsZero
        }

        return max(1, Int(fee * 100_000_000 / 1024))
    }

}
