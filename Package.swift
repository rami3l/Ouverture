// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ouverture",
    products: [
        .executable(name: "ovt", targets: ["ovt"]),
        .library(name: "Ouverture", targets: ["Ouverture"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
        .package(
            url: "https://github.com/IBM-Swift/HeliumLogger.git",
            from: "2.0.0"
        ),
        .package(
            name: "swift-argument-parser",
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.2"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Ouverture",
            dependencies: ["HeliumLogger"]
        ),
        .target(
            name: "ovt",
            dependencies: [
                "Ouverture",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                ),
            ]
        ), .testTarget(name: "OuvertureTests", dependencies: ["Ouverture"]),
    ]
)
