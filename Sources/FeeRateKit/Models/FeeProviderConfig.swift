public struct FeeProviderConfig {
    let ethEvmUrl: String
    let ethEvmAuth: String?
    let bscEvmUrl: String
    let mempoolSpaceUrl: String

    public init(ethEvmUrl: String, ethEvmAuth: String? = nil, bscEvmUrl: String, mempoolSpaceUrl: String) {
        self.ethEvmUrl = ethEvmUrl
        self.ethEvmAuth = ethEvmAuth
        self.bscEvmUrl = bscEvmUrl
        self.mempoolSpaceUrl = mempoolSpaceUrl
    }

    public static var defaultBscEvmUrl: String {
        "https://bsc-dataseed.binance.org/"
    }

    public static func infuraUrl(projectId: String) -> String {
        "https://mainnet.infura.io/v3/\(projectId)"
    }

}
