// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ButtonConfig",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "ButtonConfig",
            targets: ["ButtonConfig"]),
    ],
    dependencies: [.package(name: "FWCommonProtocols", url: "https://github.com/franklynw/FWCommonProtocols.git", .upToNextMajor(from: "1.0.0")),
                   .package(name: "FWMenu", url: "https://github.com/franklynw/FWMenu.git", .upToNextMajor(from: "2.0.0"))],
    targets: [
        .target(
            name: "ButtonConfig",
            dependencies: ["FWCommonProtocols", "FWMenu"]),
        .testTarget(
            name: "ButtonConfigTests",
            dependencies: ["ButtonConfig"]),
    ]
)
