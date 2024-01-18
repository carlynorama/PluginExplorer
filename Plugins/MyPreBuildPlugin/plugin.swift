//
//  MyPreBuildPlugin.swift
//
//
//  Created by Carlyn Maw on 1/17/24.
//


import PackagePlugin
import Foundation

@main
struct MyPreBuildPlugin:BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let outputDir = context.pluginWorkDirectory//.appending(["snapshot.zip"])
        let folder = target.directory.lastComponent
        let zipNCleanCommand = "cd \(target.directory.removingLastComponent().string) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folder) && cd - && cd \(outputDir) && ls -1t | tail -n +6 | xargs rm -f"
        //let zipCommand = "cd \(target.directory.removingLastComponent().string) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folder)"
        print("from MPBP:", outputDir)
        let result:[PackagePlugin.Command] =  [.prebuildCommand(
            displayName: "------------ MyPreBuildPlugin ------------",
            executable: .init("/bin/zsh"), //also Path("/bin/zsh")
            arguments: ["-c", zipNCleanCommand],
            //environment: [:], manually clearing the environment did not help
            outputFilesDirectory: outputDir)
        ]
        
        //works in that it makes files and deletes them, but problematic b/c running
        //it creates copy resources warnings & errors e.g.
        //WARNING: Skipping duplicate build file in Copy Bundle Resources build phase: Users/.../MyPreBuildPlugin/snapshot_2024-01-17T16-29-14.zip
        //FAILURE: CpResource... error: /Users/.../MyPreBuildPlugin/snapshot_2024-01-17T16-30-04.zip: No such file or directory (in target 'PluginExplorer_plugin-tester' from project 'PluginExplorer')
        //result.append(removeExcessFiles(directory: outputDir))
        
        //As it turns out appending _any_ new command to the array triggers the warnings,
        //but no error when `zipNCleanCommand` is used.
        //When run those same commands as their own plugin it's fine.
        
        //Have moved the ls and echo tests to ScreamIntoTheVoid plugin for more testing.
        
        
        
        return result
    }
    
    //WARNING: Only works if no spaces in file names.
    func removeExcessFiles(directory:Path) -> PackagePlugin.Command {
        let removeCommand = "cd \(directory.string) && ls -1t | tail -n +6 | xargs rm -f"
        return .prebuildCommand(displayName: "Remove Stalest",
                                executable: .init("/bin/zsh"),
                                arguments: ["-c", removeCommand],
                                //environment: [:],
                                outputFilesDirectory: directory
        )
    }
    
    
}


//------------------------------ MORE STORAGE
//let outputFile = context.pluginWorkDirectory.appending(["snapshot.zip"])
//return [.prebuildCommand(
//    displayName: "------------ MyPreBuildPlugin ------------",
//    executable: .init("/usr/bin/zip"), //also Path("/usr/bin/zip")
//    arguments: ["\(outputFile)", target.directory.string],
//    //environment: T##[String : CustomStringConvertible],
//    outputFilesDirectory: outputFile.removingLastComponent())
//]

//problematic because assembled at plugin build time not runtime?
//func removeFile(directory:Path, file:String) -> PackagePlugin.Command {
//    .prebuildCommand(displayName: "Remove Stalest",
//                     executable: .init("/bin/rm"),
//                     arguments: [directory.appending([file]).string],
//                     outputFilesDirectory: directory
//    )
//}



