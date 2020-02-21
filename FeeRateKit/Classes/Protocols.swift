import RxSwift

protocol IStorage {
    func feeRate(coin: Coin) -> FeeRate?
    func save(feeRate: FeeRate)
}

protocol IFeeRateProvider {
    func getFeeRates() -> Single<FeeRate>
}

protocol IBtcParametersProvider {
    func url(for priority: RequestPriority) -> String
    func parameters(for priority: RequestPriority) -> [String: Any]
    var auth: (String, String)? { get }
}
