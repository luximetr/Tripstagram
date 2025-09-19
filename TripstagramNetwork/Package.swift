// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TripstagramNetwork",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TripstagramNetwork",
            targets: ["TripstagramNetwork"]
        ),
    ],
    targets: [
        .target(
            name: "TripstagramNetwork",
            path: "TripstagramNetwork",
        ),
        .testTarget(
            name: "TripstagramNetworkTests",
            dependencies: ["TripstagramNetwork"],
            path: "TripstagramNetworkTests",
        ),
    ]
)
