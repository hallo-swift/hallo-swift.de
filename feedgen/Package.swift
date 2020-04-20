// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "feedgen",
    products: [
        .library(
            name: "Feedgen",
            targets: ["FeedGenCore"]),
        .executable(
            name: "feedgen",
            targets: ["feedgen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.0.5")),
        .package(url: "https://github.com/dduan/TOMLDecoder.git", from: "0.1.5"),
        .package(url: "https://github.com/sharplet/Regex.git", from: "2.1.1"),
        .package(url: "https://github.com/JohnSundell/Ink.git", from: "0.4.0"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/alexaubry/HTMLString.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "feedgen",
            dependencies: ["FeedGenCore"]),
        .target(
            name: "FeedGenCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "TOMLDecoder",
                "Regex",
                "Ink",
                "Stencil",
                "HTMLString",
            ]),
        .testTarget(
            name: "feedgenTests",
            dependencies: ["FeedGenCore"]),
    ]
)
