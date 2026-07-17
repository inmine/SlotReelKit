// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SlotReelKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SlotReelKit",
            targets: ["SlotReelKit"]
        )
    ],
    targets: [
        .target(
            name: "SlotReelKit",
            path: "SlotReelKit"
        )
    ]
)
