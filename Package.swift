// swift-tools-version: 6.3

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Sigil",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(name: "Sigil", targets: ["Sigil"]),
        .library(name: "SigilScan", targets: ["SigilScan"]),
        .executable(name: "sigil", targets: ["SigilCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "6.2.1"),
    ],
    targets: [
        .macro(
            name: "SigilMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(name: "Sigil", dependencies: ["SigilMacros"]),
        .target(
            name: "SigilScan",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "Yams", package: "Yams"),
            ]
        ),
        .executableTarget(
            name: "SigilCLI",
            dependencies: [
                "SigilScan",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(name: "SigilTests", dependencies: ["Sigil"]),
        .testTarget(
            name: "SigilMacrosTests",
            dependencies: [
                "SigilMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
            ]
        ),
        .testTarget(name: "SigilScanTests", dependencies: ["SigilScan"]),
    ]
)
