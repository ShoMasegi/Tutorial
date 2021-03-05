// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkPlatform",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "NetworkPlatform",
            targets: ["NetworkPlatform"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .exact("14.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("5.1.1")),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "NetworkPlatform",
            dependencies: [
                "Domain",
                "Moya",
                "RxSwift",
                .product(name: "RxMoya", package: "Moya")
            ]),
        .testTarget(
            name: "NetworkPlatformTests",
            dependencies: ["NetworkPlatform"]),
    ]
)
