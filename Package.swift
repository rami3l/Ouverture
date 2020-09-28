// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ouverture",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
        .package(
            url: "https://github.com/IBM-Swift/HeliumLogger.git",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/IBM-Swift/LoggerAPI.git",
            from: "1.9.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Ouverture",
            dependencies: ["HeliumLogger", "LoggerAPI"]
        ), .testTarget(name: "OuvertureTests", dependencies: ["Ouverture"]),
    ]
)
