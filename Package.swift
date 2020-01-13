// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Observable",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Observable", targets: ["Observable"])
    ],
    targets: [
        .target(name: "Observable", path: "Observable/Classes"),
        .testTarget(
            name: "ObservableTests",
            dependencies: ["Observable"],
            path: "Observable/Tests"
        ),
    ]
)
