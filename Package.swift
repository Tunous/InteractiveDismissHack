// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "InteractiveDismissHack",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "InteractiveDismissHack",
            targets: ["InteractiveDismissHack"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "InteractiveDismissHack",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ]
        ),
        .testTarget(
            name: "InteractiveDismissHackTests",
            dependencies: [
                "InteractiveDismissHack",
            ]
        ),
    ]
)
