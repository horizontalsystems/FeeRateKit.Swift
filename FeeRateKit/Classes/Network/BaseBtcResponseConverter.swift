import Foundation

class BaseBtcResponseConverter {

    func convert(response: Any) -> Int? {
        guard let map = response as? [String: Any] else {
            return nil
        }

        guard let result = map["result"] as? [String: Any] else {
            return nil
        }

        guard let fee = (result["fee"] as? Double) ?? (result["feerate"] as? Double) else {
            return nil
        }

        guard fee > 0 else {
            return nil
        }

        return max(1, Int(fee * 100_000_000 / 1024))
    }

}
