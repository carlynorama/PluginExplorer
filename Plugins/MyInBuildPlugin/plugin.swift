import PackagePlugin
import Foundation

//Example Build Plugin: All inputs and output names are known before the tool runs.

//If you know what the output file name will be at this stage, its a build command.
//If you need to open the input files and manipulate them to figure out what the
//file names will be, its a prebuild command.

//Build plugins only run if the input files have changed, or if an output file is missing.

//more info: https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#build-tool-plugins

//Print statements can be found in build log in Xcode

@main
struct MyInBuildPlugin:BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        //if target doesn't have source files, don't run the tool. 
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        let dataDirectory = target.directory.appending(["Data"]) 
        
        let dataContents = try FileManager.default.contentsOfDirectory(atPath: dataDirectory.string).map { fileName in
                dataDirectory.appending([fileName])
        }

        let outputFileName = "FruitStore.swift"
        let outputFiles:[Path] = [context.pluginWorkDirectory.appending([outputFileName])]
        
        
        return [.buildCommand(displayName: "Test.",
                                         executable: try context.tool(named: "MyInBuildPluginTool").path,
                                         arguments: [dataDirectory.string, context.pluginWorkDirectory.string, outputFileName],
                                         inputFiles: dataContents,
                                         outputFiles: outputFiles)]
        
        }
        

    
    
}


/*
 //Example code from https://developer.apple.com/videos/play/wwdc2022/110401
 //example returns several build commands, but each has known inputs and outputs.
 //the advantage to this is that each file's staleness will be assessed independently. 
 guard let target = target as? SourceModuleTarget else {
     return []
}

return try target.sourceFiles(withSuffix: "xcassets").map { assetCatalog in
     let base = assetCatalog.path.stem
     let input = assetCatalog.path
     let output = context.pluginWorkDirectory.appending(["\(base).swift"])

     return .buildCommand(displayName: "Generating constants for \(base)",
                          executable: try context.tool(named: "AssetConstantsExec").path,
                          arguments: [input.string, output.string],
                          inputFiles: [input],
                          outputFiles: [output])
 }
 */
