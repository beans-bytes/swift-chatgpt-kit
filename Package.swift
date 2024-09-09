// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-chatgpt-kit",
    products: [
        .library(
            name: "swift-chatgpt-kit",
            targets: ["swift-chatgpt-kit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-server/async-http-client.git",
            from: "1.16.0"
        )
    ]
    targets: [
        .target(
            name: "swift-chatgpt-kit"),
        .testTarget(
            name: "swift-chatgpt-kitTests",
            dependencies: ["swift-chatgpt-kit"]),
    ]
)
