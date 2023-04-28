import UIKit
import FeeRateKit

class ViewController: UIViewController {
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

    @IBAction func refresh() {
        Task { [weak self, exampleBlockchains, feeRateKit] in
            do {
                var rates = [Int]()

                for blockchain in exampleBlockchains {
                    let rate: Int

                    switch blockchain {
                    case "BTC": rate = try await feeRateKit.bitcoin(blockCount: 10)
                    case "LTC": rate = feeRateKit.litecoin
                    case "BCH": rate = feeRateKit.bitcoinCash
                    case "DASH": rate = feeRateKit.dash
                    case "ETH": rate = try await feeRateKit.ethereum()
                    case "BSC": rate = try await feeRateKit.binanceSmartChain()
                    default: rate = 0
                    }

                    rates.append(rate)
                }

                self?.updateTextView(rates: rates)
            } catch {
                print("handle fee rate error: \(error)")
            }
        }
    }

    @MainActor
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
