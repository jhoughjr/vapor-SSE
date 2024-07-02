// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "vapor-sse",
    platforms: [
       .macOS(.v14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git",
		 from: "4.92.4"),
        .package(url: "https://github.com/orlandos-nl/SSEKit.git",
                 from: "1.0.1")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
               
                .product(name: "Vapor", package: "vapor"),
                .product(name: "SSEKit", package: "SSEKit"),


            ],
            resources: [
                .copy("Public/")],
            swiftSettings: swiftSettings
            
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
