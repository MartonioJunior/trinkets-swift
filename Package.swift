// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

// MARK: - Utilities
public enum UpcomingFeatures: String, CaseIterable {
    case existentialAny
    case fullTypedThrows
    case internalImportsByDefault
    case memberImportVisibility
    case nonescapableTypes
    case nonisolatedNonsendingByDefault
    case inferIsolatedConformances
    case valueGenerics

    var asSetting: SwiftSetting { .enableUpcomingFeature(rawValue.capitalized) }
}

public extension Array where Element == SwiftSetting {
    static var upcomingFeatures: Self { UpcomingFeatures.allCases.map(\.asSetting) }
}

func dep(local: String) -> Package.Dependency {
    .package(path: local)
}

func dep(url: String, _ version: Range<Version>, local: String = "") -> Package.Dependency {
    if local.isEmpty {
        .package(url: url, version)
    } else {
        dep(local: local)
    }
}

func lib(_ name: String, targets: String...) -> Product {
    .library(name: name, targets: targets)
}

func platformDeps(_ platforms: SupportedPlatform...) -> [SupportedPlatform] {
    platforms
}

func targetDep(name: String, package: String) -> Target.Dependency {
    .product(name: name, package: package)
}

// MARK: - Dependencies
let casePaths = targetDep(name: "CasePaths", package: "swift-case-paths")
let identifiedCollections = targetDep(name: "IdentifiedCollections", package: "swift-identified-collections")
let mathe = targetDep(name: "Mathe", package: "Mathe")
let minimal = targetDep(name: "Minimal", package: "Minimal")
let numerics = targetDep(name: "Numerics", package: "swift-numerics")
let tagged = targetDep(name: "Tagged", package: "swift-tagged")
let variety = targetDep(name: "SwiftVariety", package: "swift-variety")

let dependencies = [
    dep(url: "https://github.com/pointfreeco/swift-case-paths", .upToNextMajor(from: "1.7.0")),
    dep(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "1.1.1")),
    .package(url: "https://github.com/pointfreeco/swift-tagged", .upToNextMajor(from: "0.10.0")),
    dep(url: "https://github.com/apple/swift-numerics", .upToNextMajor(from: "1.1.0")),
    .package(url: "https://github.com/MartonioJunior/Mathe", branch: "main"),
    .package(url: "https://github.com/MartonioJunior/Minimal", branch: "main"),
    .package(url: "https://github.com/MartonioJunior/swift-variety", branch: "main")
]

// MARK: - Targets
var targets: [Target] = [
    .target(
        name: "Activities",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Collectables",
        dependencies: [identifiedCollections, variety],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Custom",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Exchanges",
        dependencies: ["Custom", "Inventory"],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Flow",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Inventory",
        dependencies: ["TrinketsUnits"],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Matches",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Meters",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Notation",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Progression",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Quests",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "SI",
        dependencies: ["TrinketsUnits"],
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Tabletop",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "Timelines",
        swiftSettings: .upcomingFeatures
    ),
    .target(
        name: "TrinketsUnits",
        dependencies: ["Notation", numerics],
        swiftSettings: .upcomingFeatures
    )
]

targets.append(
    .target(
        name: "Trinkets",
        dependencies: targets.map { Target.Dependency(stringLiteral: $0.name) },
        swiftSettings: .upcomingFeatures
    )
)

let testTargets: [Target] = targets.map {
    .testTarget(name: "\($0.name)Tests", dependencies: [Target.Dependency(stringLiteral: $0.name)] + $0.dependencies)
}

targets.append(
    .target(
        name: "SM64Trinkets",
        dependencies: ["Collectables", "Custom", "Trinkets"],
        path: "Examples/SM64"
    )
)

// MARK: - Products
let products: [Product] = [
    .library(
        name: "Trinkets",
        targets: targets.map(\.name)
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
    defaultLocalization: "en",
    platforms: supportedPlatforms,
    products: products,
    dependencies: dependencies,
    targets: targets + testTargets,
    swiftLanguageModes: [.v6]
)
