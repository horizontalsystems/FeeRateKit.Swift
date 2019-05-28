import RxSwift

public class FeeRateKit {
    private let refreshIntervalInMinutes = 3

    public weak var delegate: IFeeRateKitDelegate?

    private let disposeBag = DisposeBag()

    private let storage: IStorage
    private let syncer: ISyncer

    init(storage: IStorage, syncer: ISyncer) {
        self.storage = storage
        self.syncer = syncer

        Observable<Int>.timer(.seconds(0), period: .seconds(refreshIntervalInMinutes * 60), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
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

    public var dash: FeeRate {
        return feeRate(coin: .dash)
    }

    public var ethereum: FeeRate {
        return feeRate(coin: .ethereum)
    }

    public func refresh() {
        syncer.sync()
    }

}

extension FeeRateKit {

    public static func instance(infuraProjectId: String? = nil, infuraProjectSecret: String? = nil, minLogLevel: Logger.Level = .error) -> FeeRateKit {
        let logger = Logger(minLogLevel: minLogLevel)

        let storage: IStorage = GrdbStorage()
        let networkManager = NetworkManager(logger: logger)
        var syncer: ISyncer = Syncer(networkManager: networkManager, storage: storage, infuraProjectId: infuraProjectId, infuraProjectSecret: infuraProjectSecret)

        let kit = FeeRateKit(storage: storage, syncer: syncer)

        syncer.delegate = kit

        return kit
    }

}
