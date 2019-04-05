import RxSwift

class Syncer {
    weak var delegate: ISyncerDelegate?

    private let disposeBag = DisposeBag()

    private let apiProvider: IApiProvider
    private let storage: IStorage

    init(apiProvider: IApiProvider, storage: IStorage) {
        self.apiProvider = apiProvider
        self.storage = storage
    }

}

extension Syncer: ISyncer {

    func sync() {
        apiProvider.ratesSingle(coins: Coin.allCases)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { [weak self] rates in
                    self?.storage.save(feeRates: rates)
                    self?.delegate?.didSync()
                })
                .disposed(by: disposeBag)
    }

}
