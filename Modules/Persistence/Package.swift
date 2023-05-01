// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Persistence",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Persistence",
            targets: ["Persistence"]),
    ],
    dependencies: [
        .package(path: "Common")
    ],
    targets: [
        .target(
            name: "Persistence",
            dependencies: ["Common"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"]
        ),
    ]
)
