import UIKit
import FeeRateKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()

    @IBOutlet weak var textView: UITextView?

    private let dateFormatter = DateFormatter()
    private let feeRateKit = FeeRateKit.instance(providerConfig: FeeProviderConfig(infuraProjectId: "2a1306f1d12f4c109a4d4fb9be46b02e", infuraProjectSecret: "fc479a9290b64a84a15fa6544a130218", btcCoreRpcUrl: "https://btc.horizontalsystems.xyz/apg/", btcCoreRpcUser: nil, btcCoreRpcPassword: nil))

    private let exampleCoins = ["BTC", "BCH", "DASH", "ETH"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMM d, hh:mm:ss")

        updateTextView(rates: [])
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

    private func updateTextView(rates: [FeeRate]) {
        guard rates.count == exampleCoins.count else {
            return
        }

        textView?.text = format(title: "Bitcoin", rate: rates[0]) +
                format(title: "Bitcoin Cash", rate: rates[1]) +
                format(title: "Dash", rate: rates[2]) +
                format(title: "Ethereum", rate: rates[3])
    }

    private func format(title: String, rate: FeeRate) -> String {
        "[\(title)]\n" +
                "Date: \(dateFormatter.string(from: rate.date))\n" +
                "Rates: low: \(rate.low), medium: \(rate.medium), high: \(rate.high)\n" +
                "Durations: low: \(rate.lowPriorityDuration), medium: \(rate.mediumPriorityDuration), high: \(rate.highPriorityDuration)\n\n"
    }

}
