public struct FeeProviderConfig {
    let ethEvmUrl: String
    let ethEvmAuth: String?
    let bscEvmUrl: String
    let btcCoreRpcUrl: String
    let btcCoreRpcUser: String?
    let btcCoreRpcPassword: String?

    public init(ethEvmUrl: String, ethEvmAuth: String? = nil, bscEvmUrl: String, btcCoreRpcUrl: String, btcCoreRpcUser: String?, btcCoreRpcPassword: String?) {
        self.ethEvmUrl = ethEvmUrl
        self.ethEvmAuth = ethEvmAuth
        self.bscEvmUrl = bscEvmUrl
        self.btcCoreRpcUrl = btcCoreRpcUrl
        self.btcCoreRpcUser = btcCoreRpcUser
        self.btcCoreRpcPassword = btcCoreRpcPassword
    }

    public static var defaultBscEvmUrl: String {
        "https://bsc-dataseed.binance.org/v3"
    }

    public static func infuraUrl(projectId: String) -> String {
        "https://mainnet.infura.io/v3/\(projectId)"
    }

}
