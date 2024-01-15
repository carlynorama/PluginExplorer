// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PluginExplorer",
    products: [
        .plugin(name: "TellMeAboutYourself",
          targets: ["TellMeAboutYourself"])
    ],
    targets: [
        .plugin(
            name: "TellMeAboutYourself",
            capability: .command(intent: .custom(verb: "about",
                                                 description: "See info about the package"),
                                 permissions: [.writeToPackageDirectory(reason: "This plugin creates a file with information about the plugin and the package it's running on.")])
        ),
    ]
)
