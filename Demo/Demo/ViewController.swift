import UIKit
import FeeRateKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    @IBOutlet weak var textView: UITextView?

    private let dateFormatter = DateFormatter()
    private let feeRateKit = Kit.instance(providerConfig: FeeProviderConfig(infuraProjectId: "2a1306f1d12f4c109a4d4fb9be46b02e", infuraProjectSecret: "fc479a9290b64a84a15fa6544a130218", btcCoreRpcUrl: "https://btc.horizontalsystems.xyz/apg/", btcCoreRpcUser: nil, btcCoreRpcPassword: nil))

    private let exampleCoins = ["BTC", "BCH", "DASH", "ETH"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMM d, hh:mm:ss")

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stats", style: .plain, target: self, action: #selector(onShowStats))
    }

    @IBAction func refresh() {
        Single.zip(exampleCoins.map(feeRateKit.getRate))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] feeRates in
                    self?.updateTextView(rates: feeRates)
                }, onError: { error in
                    print("handle fee rate error: \(error)")
                })
                .disposed(by: disposeBag)
    }

    @objc private func onShowStats() {
        feeRateKit.statusInfo()
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { status in
                    print(status)
                })
                .disposed(by: disposeBag)
    }

    private func updateTextView(rates: [FeeRate]) {
        let data: [(String, FeeRate)] = rates.enumerated().map { (exampleCoins[$0.offset], $0.element) }
        textView?.text = data.reduce("") { $0 + format(data: $1) }
    }

    private func format(data: (String, FeeRate)) -> String {
        let coin = data.0
        let rate = data.1
        return "[\(name(from: coin))]\n" +
                "Date: \(dateFormatter.string(from: rate.date))\n" +
                "Rates: low: \(rate.low), medium: \(rate.medium), high: \(rate.high)\n" +
                "Durations: low: \(rate.lowPriorityDuration), medium: \(rate.mediumPriorityDuration), high: \(rate.highPriorityDuration)\n\n"
    }

    private func name(from code: String) -> String {
        switch code {
        case "BTC": return "Bitcoin"
        case "ETH": return "Ethereum"
        case "DASH": return "Dash"
        case "BCH": return "Bitcoin Cash"
        default: return "Unknown" 
        }
    }

}
