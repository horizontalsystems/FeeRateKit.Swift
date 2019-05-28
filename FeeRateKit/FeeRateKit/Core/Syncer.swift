import RxSwift

class Syncer {
    weak var delegate: ISyncerDelegate?

    private let disposeBag = DisposeBag()

    private let storage: IStorage

    private let hsIpfsApiProvider: IpfsApiProvider
    private let globalIpfsApiProvider: IpfsApiProvider

    private let bcoinApiProvider: BcoinApiProvider
    private var infuraApiProvider: InfuraApiProvider?

    init(networkManager: NetworkManager, storage: IStorage, infuraProjectId: String?, infuraProjectSecret: String? = nil) {
        self.storage = storage

        hsIpfsApiProvider = IpfsApiProvider(networkManager: networkManager, baseUrl: "https://ipfs-ext.horizontalsystems.xyz", timeoutInterval: 20)
        globalIpfsApiProvider = IpfsApiProvider(networkManager: networkManager, baseUrl: "https://ipfs.io", timeoutInterval: 40)

        bcoinApiProvider = BcoinApiProvider(networkManager: networkManager, baseUrl: "https://btc.horizontalsystems.xyz/apg")

        if let infuraProjectId = infuraProjectId {
            infuraApiProvider = InfuraApiProvider(networkManager: networkManager, projectId: infuraProjectId, projectSecret: infuraProjectSecret)
        }
    }

    private func syncFromApi() {
        syncBitcoinFromApi()
        syncEthereumFromApi()
    }

    private func syncBitcoinFromApi() {
        bcoinApiProvider.bitcoinRateSingle()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { [weak self] rate in
                    self?.storage.save(feeRates: [rate])
                    self?.delegate?.didSync()
                })
                .disposed(by: disposeBag)
    }

    private func syncEthereumFromApi() {
        guard let infuraApiProvider = infuraApiProvider else {
            return
        }

        infuraApiProvider.ethereumRateSingle()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { [weak self] rate in
                    self?.storage.save(feeRates: [rate])
                    self?.delegate?.didSync()
                })
                .disposed(by: disposeBag)
    }

}

extension Syncer: ISyncer {

    func sync() {
        hsIpfsApiProvider.ratesSingle(coins: Coin.allCases)
                .catchError { [unowned self] _ in
                    return self.globalIpfsApiProvider.ratesSingle(coins: Coin.allCases)
                }
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onSuccess: { [weak self] rates in
                    self?.storage.save(feeRates: rates)
                    self?.delegate?.didSync()
                }, onError: { [weak self] _ in
                    self?.syncFromApi()
                })
                .disposed(by: disposeBag)
    }

}
