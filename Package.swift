// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PluginExplorer",
    products: [
        .executable(name:"plugin-tester", targets: ["plugin-tester"]),
        .plugin(name: "TellMeAboutYourself",
          targets: ["TellMeAboutYourself"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name:"plugin-tester",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path:"Sources/PluginTesterCLI",
            exclude: ["Data"],
            plugins: ["MyInBuildPlugin"]
        ),
        .plugin(
            name: "TellMeAboutYourself",
            capability: .command(intent: .custom(verb: "about",
                                                 description: "See info about the package"),
                                 permissions: [.writeToPackageDirectory(reason: "This plugin creates a file with information about the plugin and the package it's running on.")])
        ),
        .executableTarget(name: "MyInBuildPluginTool"),
        .plugin(name: "MyInBuildPlugin", capability: .buildTool(), dependencies: ["MyInBuildPluginTool"])
    ]
)
