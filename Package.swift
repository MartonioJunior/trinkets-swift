// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Dependencies
let numerics: Target.Dependency = .product(name: "Numerics", package: "swift-numerics")

let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-numerics", .upToNextMajor(from: "1.0.2"))
]

// MARK: - Swift Settings
let settings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("FullTypedThrows"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("NonescapableTypes"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("ValueGenerics")
]

// MARK: - Targets
let targets: [Target] = [
    .target(
        name: "SI",
        dependencies: ["TrinketsUnits"]
    ),
    .target(
        name: "Trinkets",
        dependencies: ["SI", "TrinketsUnits", numerics]
    ),
    .target(
        name: "TrinketsUnits"
    )
]

let testTargets: [Target] = targets.map {
    .testTarget(name: "\($0.name)Tests", dependencies: [Target.Dependency(stringLiteral: $0.name)] + $0.dependencies)
}

// MARK: - Products
let products: [Product] = [
    .library(
        name: "Trinkets",
        targets: ["Trinkets"]
    ),
    .library(
        name: "UnitSI",
        targets: ["TrinketsUnits", "SI"]
    )
]

// MARK: - Supported Platforms
let supportedPlatforms: [SupportedPlatform] = [
    .macOS(.v13)
]

// MARK: PackageDescription
let package = Package(
    name: "Trinkets",
    platforms: supportedPlatforms,
    products: products,
    dependencies: dependencies,
    targets: targets + testTargets
)
