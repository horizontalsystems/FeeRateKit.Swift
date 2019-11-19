public struct FeeProviderConfig {
    let infuraProjectId: String
    let infuraProjectSecret: String?
    let infuraApiUrl: String?
    let btcCoreRpcUrl: String
    let btcCoreRpcUser: String?
    let btcCoreRpcPassword: String?

    public init(infuraProjectId: String, infuraProjectSecret: String?, infuraApiUrl: String? = nil, btcCoreRpcUrl: String, btcCoreRpcUser: String?, btcCoreRpcPassword: String?) {
        self.infuraProjectId = infuraProjectId
        self.infuraProjectSecret = infuraProjectSecret
        self.infuraApiUrl = infuraApiUrl
        self.btcCoreRpcUrl = btcCoreRpcUrl
        self.btcCoreRpcUser = btcCoreRpcUser
        self.btcCoreRpcPassword = btcCoreRpcPassword
    }

}
