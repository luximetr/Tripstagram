// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TripstagramStorage",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TripstagramStorage",
            targets: ["TripstagramStorage"]
        ),
    ],
    targets: [
        .target(
            name: "TripstagramStorage",
            path: "TripstagramStorage",
        ),
        .testTarget(
            name: "TripstagramStorageTests",
            dependencies: ["TripstagramStorage"],
            path: "TripstagramStorageTests",
        ),
    ]
)
