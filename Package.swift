// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "netfox",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "netfox",
            targets: ["netfox"]
        ),
    ],
    targets: [
        .target(name: "netfox",
                path: "netfox/",
                exclude: ["OSX"])
    ],
    swiftLanguageVersions: [.v5]
)
