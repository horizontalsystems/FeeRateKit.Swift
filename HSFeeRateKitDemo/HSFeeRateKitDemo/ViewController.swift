import UIKit
import HSFeeRateKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feeRateKit = FeeRateKit()
        print(feeRateKit.testString)
    }

}
