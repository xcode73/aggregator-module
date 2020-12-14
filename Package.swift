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
        
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0-beta"),
        
    ],
    targets: [
        .target(name: "AggregatorModule", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
            .product(name: "Kanna", package: "Kanna"),
        ], resources: [
            .copy("Bundle"),
        ]),
        .target(name: "Feather", dependencies: [
            .product(name: "FeatherCore", package: "feather-core"),
  
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            
            .target(name: "AggregatorModule"),
        ]),
        .testTarget(name: "AggregatorModuleTests", dependencies: [
            .target(name: "AggregatorModule"),
        ])
    ]
)
