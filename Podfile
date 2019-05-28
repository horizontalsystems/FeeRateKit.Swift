platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

workspace 'FeeRateKit'

project 'FeeRateKit/FeeRateKit'
project 'Demo/Demo'

def common_pods
  pod 'RxSwift', '~> 5.0'
  pod 'Alamofire', '~> 4.0'
  pod 'GRDB.swift', '~> 4.0'
end

target :FeeRateKit do
  project 'FeeRateKit/FeeRateKit'
  common_pods
end

target :Demo do
  project 'Demo/Demo'
  common_pods
end

target :FeeRateKitTests do
  project 'FeeRateKit/FeeRateKit'
  pod 'Cuckoo'
  pod 'Quick'
  pod 'Nimble'
end
