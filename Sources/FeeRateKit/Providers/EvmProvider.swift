import HsToolKit
import RxSwift
import Alamofire

class EvmProvider {
    private let networkManager: NetworkManager
    private let url: String
    private let auth: String?

    init(networkManager: NetworkManager, url: String, auth: String? = nil) {
        self.networkManager = networkManager
        self.url = url
        self.auth = auth
    }

    func getFeeRate() -> Single<Int> {
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

        let request = networkManager.session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)

        return networkManager.single(request: request, mapper: self)
    }

}

extension EvmProvider: IApiMapper {

    enum ResponseError: Error {
        case noResult
        case wrongFeeFormat
    }

    public func map(statusCode: Int, data: Any?) throws -> Int {
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

        return fee
    }

}

