import RxSwift

class BtcHorsysProvider {
    private let btcCoreRpcUrl: String

    init(config: FeeProviderConfig) {
        self.btcCoreRpcUrl = config.btcCoreRpcUrl
    }

}

extension BtcHorsysProvider: IBtcParametersProvider {

    func url(for priority: RequestPriority) -> String {
        btcCoreRpcUrl + priority.rawValue
    }

    func parameters(for priority: RequestPriority) -> [String: Any] {
        [:]
    }

    var auth: (String, String)? {
        nil
    }

}
