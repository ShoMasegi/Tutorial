// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Domain",
            targets: ["Domain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("5.1.1"))
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: ["RxSwift"]),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"]),
    ]
)
