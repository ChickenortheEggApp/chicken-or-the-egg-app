// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ChickenOrTheEggApp",
    platforms: [
        .iOS(.v12)
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "10.0.0"
        )
    ],
    targets: [
        .target(
            name: "ChickenOrTheEggApp",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ]
        )
    ]
)
