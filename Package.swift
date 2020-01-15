// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "StackViewController",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "StackViewController",
            targets: ["StackViewController"]
        )
    ],
    targets: [
        .target(
            name: "StackViewController",
            path: "StackViewController"
        ),
        .testTarget(
            name: "StackViewControllerTests",
            dependencies: ["StackViewController"],
            path: "StackViewControllerTests"
        )
    ]
)
