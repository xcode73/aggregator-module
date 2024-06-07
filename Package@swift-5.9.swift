// swift-tools-version:5.9
import PackageDescription
import Foundation

let package = Package(
    name: "aggregator-module",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AggregatorModule", targets: ["AggregatorModule"]),
        .library(name: "AggregatorApi", targets: ["AggregatorApi"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xcode73/feather-core.git", branch: "main"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.3.0"),
    ],
    targets: [
        .target(
            name: "AggregatorApi",
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
        .target(
            name: "AggregatorModule",
            dependencies: [
                .product(name: "FeatherCore", package: "feather-core"),
                .product(name: "Kanna", package: "Kanna"),
                .target(name: "AggregatorApi"),
            ],
            resources: [
                //            .copy("Bundle"),
            ],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=complete")]
        ),
    ]
)
