// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TripstagramSQLite3",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "TripstagramSQLite3",
            targets: ["TripstagramSQLite3"]
        ),
    ],
    targets: [
        .target(
            name: "TripstagramSQLite3",
            path: "TripstagramSQLite3"
        ),

    ]
)
