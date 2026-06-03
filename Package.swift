// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "libntrip-swift",
    platforms: [
        .macOS("10.15.4"),
        .iOS(.v16)
    ],
    products: [
        .library(name: "NTRIP", targets: ["NTRIP"]),
        .library(name: "RTCM3", targets: ["RTCM3"]),
        .executable(name: "ntrip-client", targets: ["NTRIPClient"]),
        .executable(name: "ntrip-server", targets: ["NTRIPServer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: "NTRIP",
            dependencies: []
        ),
        .target(
            name: "RTCM3",
            dependencies: ["NTRIP"]
        ),
        .executableTarget(
            name: "NTRIPClient",
            dependencies: [
                "NTRIP",
                "RTCM3",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .executableTarget(
            name: "NTRIPServer",
            dependencies: [
                "NTRIP",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "NTRIPTests",
            dependencies: ["NTRIP"]
        ),
        .testTarget(
            name: "RTCM3Tests",
            dependencies: ["RTCM3"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
