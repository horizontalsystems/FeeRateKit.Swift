import RxSwift

class BtcCoreProvider {
    private let btcCoreRpcUrl: String
    private let btcCoreRpcUser: String?
    private let btcCoreRpcPassword: String?

    init(config: FeeProviderConfig) {
        self.btcCoreRpcUrl = config.btcCoreRpcUrl
        self.btcCoreRpcUser = config.btcCoreRpcUser
        self.btcCoreRpcPassword = config.btcCoreRpcPassword
    }

}

extension BtcCoreProvider: IBtcParametersProvider {

    func url(for priority: RequestPriority) -> String {
        btcCoreRpcUrl
    }

    func parameters(for priority: RequestPriority) -> [String: Any] {
        [
            "jsonrpc": "2.0",
            "method": "estimatesmartfee",
            "params": [priority.blockCount],
            "id": 1
        ]
    }

    var auth: (String, String)? {
        guard let user = btcCoreRpcUser, let password = btcCoreRpcPassword else {
            return nil
        }
        return (user, password)
    }

}
