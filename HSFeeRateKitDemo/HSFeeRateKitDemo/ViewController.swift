import UIKit
import HSFeeRateKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView?

    private let dateFormatter = DateFormatter()
    private let feeRateKit = FeeRateKit.instance(minLogLevel: .verbose)

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
                format(title: "Ethereum", rate: feeRateKit.ethereum)
    }

    private func format(title: String, rate: FeeRate) -> String {
        return "[\(title)]\n" +
                "Date: \(dateFormatter.string(from: rate.date))\n" +
                "Rates: low: \(rate.lowPriority), medium: \(rate.mediumPriority), high: \(rate.highPriority)\n\n"
    }

}

extension ViewController: IFeeRateKitDelegate {

    public func didRefreshFeeRates() {
        updateTextView()
    }

}
