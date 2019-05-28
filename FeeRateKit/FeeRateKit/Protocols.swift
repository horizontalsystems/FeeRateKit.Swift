import RxSwift

public protocol IFeeRateKitDelegate: AnyObject {
    func didRefreshFeeRates()
}

protocol IStorage {
    func feeRate(coin: Coin) -> FeeRate?
    func save(feeRates: [FeeRate])
}

protocol ISyncer {
    var delegate: ISyncerDelegate? { get set }
    func sync()
}

protocol ISyncerDelegate: AnyObject {
    func didSync()
}
