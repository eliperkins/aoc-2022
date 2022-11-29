// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "aoc-2022",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "AdventOfCode2022", targets: ["AdventOfCode2022"]),
        .executable(name: "aoc-cli", targets: ["AdventOfCodeCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "AdventOfCode2022",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Numerics", package: "swift-numerics"),
            ],
            resources: [
                .copy("Inputs")
            ]
        ),
        .executableTarget(
            name: "AdventOfCodeCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "AdventOfCode2022Tests",
            dependencies: ["AdventOfCode2022"]
        ),
    ]
)
