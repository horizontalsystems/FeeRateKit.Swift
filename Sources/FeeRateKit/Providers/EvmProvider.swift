import Alamofire
import HsToolKit

class EvmProvider {
    private let networkManager: NetworkManager
    private let url: String
    private let auth: String?

    init(networkManager: NetworkManager, url: String, auth: String? = nil) {
        self.networkManager = networkManager
        self.url = url
        self.auth = auth
    }

    func getFeeRate() async throws -> Int {
        let parameters: [String: Any] = [
            "id": "1",
            "jsonrpc": "2.0",
            "method": "eth_gasPrice",
            "params": []
        ]

        var headers = HTTPHeaders()

        if let auth = auth {
            headers.add(.authorization(username: "", password: auth))
        }

        let json = try await networkManager.fetchJson(url: url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)

        guard let map = json as? [String: Any] else {
            throw ResponseError.invalidJson
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

        return fee
    }

}

extension EvmProvider {

    enum ResponseError: Error {
        case invalidJson
        case noResult
        case wrongFeeFormat
    }

}

