// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DominantColor",
    platforms: [
       .macOS(.v12),
       .iOS(.v14),
       .tvOS(.v14)
    ],
    products: [
        .library(name: "DominantColor", targets: ["DominantColor"]),
        .library(name: "DominantColor_Dynamic", type: .dynamic, targets: ["DominantColor"]),
    ],
    targets: [
        .target(
            name: "DominantColor",
            path: "DominantColor/Shared"
        ),
        .testTarget(
            name: "DominantColorTests",
            dependencies: ["DominantColor"],
            resources: [
                .copy("Resources/testimage.jpg")
            ]
        )
    ]
)
