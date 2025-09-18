// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "TripstagramPresentation",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TripstagramPresentation",
            targets: ["TripstagramPresentation"]
        ),
    ],
    targets: [
        .target(
            name: "TripstagramPresentation",
            path: "TripstagramPresentation",
        ),
        .testTarget(
            name: "TripstagramPresentationTests",
            dependencies: ["TripstagramPresentation"],
            path: "TripstagramPresentationTests"
        ),
    ]
)
