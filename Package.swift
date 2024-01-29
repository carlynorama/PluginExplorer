// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PluginExplorer",
    platforms: [.macOS(.v13)],
    products: [
        //.executable(name:"plugin-tester", targets: ["plugin-tester"]),
        .plugin(name: "TellMeAboutYourself",
          targets: ["TellMeAboutYourself"]),
          .plugin(name: "MyInBuildPlugin", targets: ["MyInBuildPlugin"]),
          .plugin(name:"ZiPFileWriter", targets: ["MyPreBuildPlugin"])
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
            plugins: ["MyInBuildPlugin", "MyPreBuildPlugin", "ScreamIntoTheVoid"]
        ),
        .plugin(
            name: "TellMeAboutYourself",
            capability: .command(intent: .custom(verb: "about",
                                                 description: "See info about the package"),
                                 permissions: [.writeToPackageDirectory(reason: "This plugin creates a file with information about the plugin and the package it's running on.")])
        ),
        .executableTarget(name: "MyInBuildPluginTool"),
        .plugin(name: "MyInBuildPlugin", capability: .buildTool(), dependencies: ["MyInBuildPluginTool"]),
        
        //prebuild tool that writes zip files to the directory using shell.
        .plugin(name: "MyPreBuildPlugin", capability: .buildTool()),
        
        //prebuild tool to test running echo in its own script.
        .plugin(name: "ScreamIntoTheVoid", capability: .buildTool()),
        
        //WILL NOT WORK for this target. Template only.
        .plugin(
            name: "BuildNRun",
            capability: .command(intent: .custom(
                verb: "bnr",
                description: "Customizable starter plugin for doing work before starting a build."
            ))
        ),
    ]
)
