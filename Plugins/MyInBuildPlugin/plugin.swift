import PackagePlugin
import Foundation

//Example Build Plugin: All inputs and output names are known before the tool runs.

//If you know what the output file name will be at this stage, its a build command.
//If you need to open the input files and manipulate them to figure out what the
//file names will be, its a prebuild command.

//Build plugins only run if the input files have changed, or if an output file is missing.

//more info: https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#build-tool-plugins

@main
struct MyInBuildPlugin:BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        //if taget doesn't have source files, don't run the tool. 
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        let dataDirectory = target.directory.appending(["Data"]) 
        
        let fileContents = try FileManager.default.contentsOfDirectory(atPath: dataDirectory.string)
        
        
        return try fileContents.map { dataFile in
            let path = dataDirectory.appending([dataFile])
            let structName = path.stem.uppercased()
            let input = path
            let output = context.pluginWorkDirectory.appending(["\(structName).swift"])
            
            return .buildCommand(displayName: "Test.",
                                 executable: try context.tool(named: "MyInBuildPluginTool").path,
                                 arguments: [structName, input.string, output.string],
                                 inputFiles: [input],
                                 outputFiles: [output])
            
        }
        }
        

    
    
}
