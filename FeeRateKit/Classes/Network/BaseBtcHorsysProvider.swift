import RxSwift

class BaseBtcHorsysProvider {
    private let coinCode: String

    init(coinCode: String) {
        self.coinCode = coinCode
    }

}

extension BaseBtcHorsysProvider: IBtcParametersProvider {

    func url(for priority: RequestPriority) -> String {
        "https://\(coinCode).horizontalsystems.xyz/services/fee/\(priority.rawValue)"
    }

    func parameters(for priority: RequestPriority) -> [String: Any] {
        [:]
    }

    var auth: (String, String)? {
        nil
    }

}
