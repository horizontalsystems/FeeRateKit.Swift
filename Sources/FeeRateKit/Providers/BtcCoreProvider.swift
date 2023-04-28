import Alamofire
import HsToolKit

class BtcCoreProvider {
    private let networkManager: NetworkManager
    private let btcCoreRpcUrl: String
    private let btcCoreRpcUser: String?
    private let btcCoreRpcPassword: String?

    init(networkManager: NetworkManager, config: FeeProviderConfig) {
        self.networkManager = networkManager
        btcCoreRpcUrl = config.btcCoreRpcUrl
        btcCoreRpcUser = config.btcCoreRpcUser
        btcCoreRpcPassword = config.btcCoreRpcPassword
    }
    
    func getFeeRate(blockCount: Int) async throws -> Int {
        var headers = HTTPHeaders()

        if let auth = auth {
            headers.add(.authorization(username: auth.0, password: auth.1))
        }

        let json = try await networkManager.fetchJson(
            url: url(for: blockCount),
            method: .post,
            parameters: parameters(for: blockCount),
            encoding: JSONEncoding.default,
            headers: headers
        )

        guard let map = json as? [String: Any] else {
            throw ResponseError.invalidJson
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

    private func url(for blockCount: Int) -> String {
        btcCoreRpcUrl
    }

    private func parameters(for blockCount: Int) -> [String: Any] {
        [
            "jsonrpc": "1.0",
            "method": "estimatesmartfee",
            "params": [blockCount],
            "id": 1
        ]
    }

    private var auth: (String, String)? {
        guard let user = btcCoreRpcUser, let password = btcCoreRpcPassword else {
            return nil
        }
        return (user, password)
    }

}

extension BtcCoreProvider {

    enum ResponseError: Error {
        case invalidJson
        case noResult
        case noFeeRate
        case feeIsZero
    }

}
