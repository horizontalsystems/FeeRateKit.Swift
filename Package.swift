// swift-tools-version:5.5
import PackageDescription

let package = Package(
        name: "FeeRateKit",
        platforms: [
          .iOS(.v13),
        ],
        products: [
          .library(
                  name: "FeeRateKit",
                  targets: ["FeeRateKit"]
          ),
        ],
        dependencies: [
          .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.1")),
                    .package(url: "https://github.com/horizontalsystems/HsToolKit.Swift.git", .upToNextMajor(from: "1.0.0")),

        ],
        targets: [
          .target(
                  name: "FeeRateKit",
                  dependencies: [
                    "RxSwift",
                    .product(name: "HsToolKit", package: "HsToolKit.Swift"),
                  ]
          )
        ]
)
