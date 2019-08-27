import UIKit
import FeeRateKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView?

    private let dateFormatter = DateFormatter()
    private let feeRateKit = FeeRateKit.instance(infuraProjectId: "2a1306f1d12f4c109a4d4fb9be46b02e", infuraProjectSecret: "fc479a9290b64a84a15fa6544a130218", minLogLevel: .verbose)

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMM d, hh:mm:ss")

        feeRateKit.delegate = self

        updateTextView()
    }

    @IBAction func refresh() {
        feeRateKit.refresh()
    }

    private func updateTextView() {
        textView?.text = format(title: "Bitcoin", rate: feeRateKit.bitcoin) +
                format(title: "Bitcoin Cash", rate: feeRateKit.bitcoinCash) +
                format(title: "Dash", rate: feeRateKit.dash) +
                format(title: "Ethereum", rate: feeRateKit.ethereum)
    }

    private func format(title: String, rate: FeeRate) -> String {
        return "[\(title)]\n" +
                "Date: \(dateFormatter.string(from: rate.date))\n" +
                "Rates: low: \(rate.low), medium: \(rate.medium), high: \(rate.high)\n" +
                "Durations: low: \(rate.lowPriorityDuration), medium: \(rate.mediumPriorityDuration), high: \(rate.highPriorityDuration)\n\n"
    }

}

extension ViewController: IFeeRateKitDelegate {

    public func didRefreshFeeRates() {
        updateTextView()
    }

}
