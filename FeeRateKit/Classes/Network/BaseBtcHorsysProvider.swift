import RxSwift

class BaseBtcHorsysProvider {
    private let btcCoreRpcUrl: String
    private let coinCode: String

    init(config: FeeProviderConfig, coinCode: String) {
        self.btcCoreRpcUrl = config.btcCoreRpcUrl
        self.coinCode = coinCode
    }

}

extension BaseBtcHorsysProvider: IBtcParametersProvider {

    func url(for priority: RequestPriority) -> String {
        [btcCoreRpcUrl, coinCode, priority.rawValue].joined(separator: "/")
    }

    func parameters(for priority: RequestPriority) -> [String: Any] {
        [:]
    }

    var auth: (String, String)? {
        nil
    }

}
