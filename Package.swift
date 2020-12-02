// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "aggregator-module",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "AggregatorModule", targets: ["AggregatorModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/binarybirds/feather-core", from: "1.0.0-beta"),
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.2.3"),
        
    ],
    targets: [
        .target(name: "AggregatorModule", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
            .product(name: "Kanna", package: "Kanna"),
        ], resources: [
            .copy("Bundle"),
        ]),
        .testTarget(name: "AggregatorModuleTests", dependencies: [
            .target(name: "AggregatorModule"),
        ])
    ]
)
