// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-chatgpt-kit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ChatGPTKit",
            targets: ["ChatGPTKit"]),
    ],
    dependencies: [],
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
            dependencies: []
        ),
        .testTarget(
            name: "WebserviceTests",
            dependencies: [
                
            ]
        ),
    ]
)
