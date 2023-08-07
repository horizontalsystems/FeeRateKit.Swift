import Alamofire
import HsToolKit
import ObjectMapper

public class MempoolSpaceProvider {
    private let networkManager: NetworkManager
    private let baseUrl: String

    init(networkManager: NetworkManager, config: FeeProviderConfig) {
        self.networkManager = networkManager
        baseUrl = config.mempoolSpaceUrl
    }
    
    func getFeeRate() async throws -> RecommendedFees {
        return try await networkManager.fetch(
            url: "\(baseUrl)/api/v1/fees/recommended",
            method: .get,
            parameters: [:]
        )
    }

}

extension MempoolSpaceProvider {

    public struct RecommendedFees: ImmutableMappable {
        public let fastestFee: Int
        public let halfHourFee: Int
        public let hourFee: Int
        public let economyFee: Int
        public let minimumFee: Int

        public init(map: Map) throws {
            fastestFee = (try? map.value("fastestFee")) ?? 0
            halfHourFee = (try? map.value("halfHourFee")) ?? 0
            hourFee = (try? map.value("hourFee")) ?? 0
            economyFee = (try? map.value("economyFee")) ?? 0
            minimumFee = (try? map.value("minimumFee")) ?? 0
        }

    }

}
