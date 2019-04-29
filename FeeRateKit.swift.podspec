Pod::Spec.new do |spec|
  spec.name = 'FeeRateKit.swift'
  spec.module_name = 'FeeRateKit'
  spec.version = '0.1'
  spec.summary = 'Fee rate provider library for BTC, BCH and ETH'
  spec.description = <<-DESC
                       FeeRateKit.swift provides low, medium and high fee rates values for blockchains using data from IPFS.
                       ```
                    DESC
  spec.homepage = 'https://github.com/horizontalsystems/blockchain-fee-rate-kit-ios'
  spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.author = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  spec.social_media_url = 'http://horizontalsystems.io/'

  spec.requires_arc = true
  spec.source = { git: 'https://github.com/horizontalsystems/blockchain-fee-rate-kit-ios.git', tag: "#{spec.version}" }
  spec.source_files = 'FeeRateKit/FeeRateKit/**/*.{h,m,swift}'
  spec.ios.deployment_target = '11.0'
  spec.swift_version = '4.2'

  spec.dependency 'RxSwift', '~> 4.0'
  spec.dependency 'Alamofire', '~> 4.0'
  spec.dependency 'GRDB.swift', '~> 3.0'
end
