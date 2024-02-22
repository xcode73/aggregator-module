// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "aggregator-module",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "AggregatorModule", targets: ["AggregatorModule"]),
//        .library(name: "AggregatorApi", targets: ["AggregatorApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xcode73/feather-core", branch: "test-dev"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.7"),
    ],
    targets: [
//        .target(name: "AggregatorApi", dependencies: [
//            .product(name: "FeatherCoreApi", package: "feather-core"),
//        ]),
        .target(name: "AggregatorModule", dependencies: [
            .product(name: "Feather", package: "feather-core"),
            .product(name: "Kanna", package: "Kanna"),

//            .target(name: "AggregatorApi"),
        ],
        resources: [
//            .copy("Bundle"),
        ]),
    ],
    swiftLanguageVersions: [.v5]
)
