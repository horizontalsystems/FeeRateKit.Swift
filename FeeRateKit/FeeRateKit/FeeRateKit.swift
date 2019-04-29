import RxSwift

public class FeeRateKit {
    private let refreshInterval: TimeInterval = 3 * 60

    public weak var delegate: IFeeRateKitDelegate?

    private let disposeBag = DisposeBag()

    private let storage: IStorage
    private let syncer: ISyncer

    init(storage: IStorage, syncer: ISyncer) {
        self.storage = storage
        self.syncer = syncer

        Observable<Int>.timer(0, period: refreshInterval, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { [weak self] _ in
                    self?.refresh()
                })
                .disposed(by: disposeBag)
    }

    private func feeRate(coin: Coin) -> FeeRate {
        return storage.feeRate(coin: coin) ?? coin.defaultFeeRate
    }

}

extension FeeRateKit: ISyncerDelegate {

    func didSync() {
        DispatchQueue.main.async {
            self.delegate?.didRefreshFeeRates()
        }
    }

}

extension FeeRateKit {

    public var bitcoin: FeeRate {
        return feeRate(coin: .bitcoin)
    }

    public var bitcoinCash: FeeRate {
        return feeRate(coin: .bitcoinCash)
    }

    public var ethereum: FeeRate {
        return feeRate(coin: .ethereum)
    }

    public func refresh() {
        syncer.sync()
    }

}

extension FeeRateKit {

    public static func instance(minLogLevel: Logger.Level = .error) -> FeeRateKit {
        let logger = Logger(minLogLevel: minLogLevel)

        let storage: IStorage = GrdbStorage()
        let networkManager = NetworkManager(logger: logger)
        let apiProvider: IApiProvider = IpfsApiProvider(networkManager: networkManager)
        var syncer: ISyncer = Syncer(apiProvider: apiProvider, storage: storage)

        let kit = FeeRateKit(storage: storage, syncer: syncer)

        syncer.delegate = kit

        return kit
    }

}
