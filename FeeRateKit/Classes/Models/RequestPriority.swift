enum RequestPriority: String {
    case low = "fee_low"
    case medium = "fee_avg"
    case high = "fee_high"

    var blockCount: Int {
        switch self {
        case .low: return 100
        case .medium: return 10
        case .high: return 1
        }
    }
}
