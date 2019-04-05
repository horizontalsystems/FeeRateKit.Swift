platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

workspace 'HSFeeRateKit'

project 'HSFeeRateKit/HSFeeRateKit'
project 'HSFeeRateKitDemo/HSFeeRateKitDemo'

def common_pods
  pod 'RxSwift', '~> 4.0'
  pod 'Alamofire', '~> 4.0'
  pod 'GRDB.swift', '~> 3.0'
end

target :HSFeeRateKit do
  project 'HSFeeRateKit/HSFeeRateKit'
  common_pods
end

target :HSFeeRateKitDemo do
  project 'HSFeeRateKitDemo/HSFeeRateKitDemo'
  common_pods
end

target :HSFeeRateKitTests do
  project 'HSFeeRateKit/HSFeeRateKit'
  pod 'Cuckoo'
  pod 'Quick'
  pod 'Nimble'
end
