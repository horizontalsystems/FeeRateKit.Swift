enum RequestPriority: String {
    case low = "low"
    case medium = "avg"
    case high = "high"

    var blockCount: Int {
        switch self {
        case .low: return 100
        case .medium: return 10
        case .high: return 1
        }
    }
}
