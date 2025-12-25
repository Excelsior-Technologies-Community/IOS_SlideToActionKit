// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SlideToActionKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SlideToActionKit",
            targets: ["SlideToActionKit"]
        )
    ],
    targets: [
        .target(
            name: "SlideToActionKit",
            path: "Sources/SlideToActionKit"
        )
    ]
)
