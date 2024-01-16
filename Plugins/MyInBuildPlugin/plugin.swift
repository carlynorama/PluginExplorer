import PackagePlugin


@main
struct MyInBuildPlugin:BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        guard let target = target as? SourceModuleTarget else {
                            return []
                        }
            let toolPath = try context.tool(named: "MyInBuildPluginTool").path
            print(toolPath)
            //return []
            return try target.sourceFiles(withSuffix: "swift").map { codefile in
                             let base = "\(codefile.path.stem)_generated"
                             let input = codefile.path
                             let output = context.pluginWorkDirectory.appending(["\(base).swift"])

                             //let input = context.package.directory
                             //let output = context.package.directory.appending(["my_output.txt"])
                             //let output = context.pluginWorkDirectory.appending(["my_output.swift"])
                             return .buildCommand(displayName: "Test.",
                                                  executable: try context.tool(named: "MyInBuildPluginTool").path,
                                                  arguments: [input.string, output.string],
                                                  inputFiles: [input],
                                                  outputFiles: [output])
                            
        }
    }
    
    
}
