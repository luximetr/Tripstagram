// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TripstagramNetwork",
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
