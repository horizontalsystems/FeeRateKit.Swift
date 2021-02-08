Pod::Spec.new do |s|
  s.name             = 'FeeRateKit.swift'
  s.module_name      = 'FeeRateKit'
  s.version          = '0.6'
  s.summary          = 'Fee rate provider library for BTC, BCH, LTC, DASH and ETH.'

  s.homepage         = 'https://github.com/horizontalsystems/blockchain-fee-rate-kit-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Horizontal Systems' => 'hsdao@protonmail.ch' }
  s.source           = { git: 'https://github.com/horizontalsystems/blockchain-fee-rate-kit-ios.git', tag: "#{s.version}" }
  s.social_media_url = 'http://horizontalsystems.io/'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'

  s.source_files = 'FeeRateKit/Classes/**/*'

  s.requires_arc = true

  s.dependency 'HsToolKit.swift', '~> 1'

  s.dependency 'RxSwift', '~> 5.0'
end
