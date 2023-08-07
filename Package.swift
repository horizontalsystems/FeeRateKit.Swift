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
          .package(url: "https://github.com/horizontalsystems/HsToolKit.Swift.git", .upToNextMajor(from: "2.0.0")),
          .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.1.0"))
        ],
        targets: [
          .target(
                  name: "FeeRateKit",
                  dependencies: [
                    .product(name: "HsToolKit", package: "HsToolKit.Swift"),
                    "ObjectMapper"
                  ]
          )
        ]
)
