import UIKit
import FeeRateKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    @IBOutlet weak var textView: UITextView?

    private let feeRateKit = Kit.instance(providerConfig: FeeProviderConfig(
            ethEvmUrl: FeeProviderConfig.infuraUrl(projectId: "2a1306f1d12f4c109a4d4fb9be46b02e"),
            ethEvmAuth: "fc479a9290b64a84a15fa6544a130218",
            bscEvmUrl: FeeProviderConfig.defaultBscEvmUrl,
            btcCoreRpcUrl: "https://btc.horizontalsystems.xyz/rpc",
            btcCoreRpcUser: nil,
            btcCoreRpcPassword: nil
    ))

    private let exampleBlockchains = ["BTC", "LTC", "BCH", "DASH", "ETH", "BSC"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getRate(blockchain: String) -> Single<Int> {
        switch blockchain {
            case "BTC": return feeRateKit.bitcoin(blockCount: 10)
            case "LTC": return feeRateKit.litecoin
            case "BCH": return feeRateKit.bitcoinCash
            case "DASH": return feeRateKit.dash
            case "ETH": return feeRateKit.ethereum
            case "BSC": return feeRateKit.binanceSmartChain
            default: return Single.just(0)
        }
    }

    @IBAction func refresh() {
        Single.zip(exampleBlockchains.map { getRate(blockchain: $0) })
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] feeRates in
                    self?.updateTextView(rates: feeRates)
                }, onError: { error in
                    print("handle fee rate error: \(error)")
                })
                .disposed(by: disposeBag)
    }

    private func updateTextView(rates: [Int]) {
        var ratesString = ""
        
        for (index, rate) in rates.enumerated() {
            ratesString += "[\(name(from: exampleBlockchains[index]))]\nRate: \(rate)\n\n"
        }
        
        textView?.text = ratesString
    }

    private func name(from blockchain: String) -> String {
        switch blockchain {
        case "BTC": return "Bitcoin"
        case "LTC": return "Litecoin"
        case "ETH": return "Ethereum"
        case "DASH": return "Dash"
        case "BCH": return "Bitcoin Cash"
        case "BSC": return "Binance Smart Chain"
        default: return "Unknown"
        }
    }

}
