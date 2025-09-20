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
    dependencies: [
        .package(path: "./TripstagramSQLite3")
    ],
    targets: [
        .target(
            name: "TripstagramStorage",
            dependencies: [
                "TripstagramSQLite3"
            ],
            path: "TripstagramStorage",
        ),
        .testTarget(
            name: "TripstagramStorageTests",
            dependencies: ["TripstagramStorage"],
            path: "TripstagramStorageTests",
        ),
    ]
)
