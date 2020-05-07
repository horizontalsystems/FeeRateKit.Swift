import HsToolKit
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

        let request = networkManager.session.request(url, method: .post, parameters: parameters)

        return networkManager.single(request: request, mapper: self)
    }

}

extension InfuraProvider: IApiMapper {

    enum ResponseError: Error {
        case noResult
        case wrongFeeFormat
    }

    public func map(statusCode: Int, data: Any?) throws -> FeeRate {
        guard let map = data as? [String: Any] else {
            throw NetworkManager.RequestError.invalidResponse(statusCode: statusCode, data: data)
        }

        guard var hex = map["result"] as? String else {
            throw ResponseError.noResult
        }

        let prefix = "0x"

        if hex.hasPrefix(prefix) {
            hex = String(hex.dropFirst(prefix.count))
        }

        guard let fee = Int(hex, radix: 16) else {
            throw ResponseError.wrongFeeFormat
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

