// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-chatgpt-kit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ChatGPTKit",
            targets: ["ChatGPTKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-server/async-http-client.git",
            exact: "1.22.1"
        )
    ],
    targets: [
        .target(
            name: "ChatGPTKit",
            dependencies: [
                "Webservice"
            ]
        ),
        .testTarget(
            name: "ChatGPTKitTests",
            dependencies: [
                "ChatGPTKit"
            ]
        ),
        .target(
            name: "Webservice",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
        .testTarget(
            name: "WebserviceTests",
            dependencies: [
                
            ]
        ),
    ]
)
