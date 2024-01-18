//
//  File.swift
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
        //let zipNCleanCommand = "cd \(target.directory.removingLastComponent().string) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folder) && cd - && cd \(outputDir) && ls -1t | tail -n +6 | xargs rm -f"
        let zipCommand = "cd \(target.directory.removingLastComponent().string) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folder)"
        print("print from plugin.swift:", outputDir)
        var result:[PackagePlugin.Command] =  [.prebuildCommand(
            displayName: "------------ MyPreBuildPlugin ------------",
            executable: .init("/bin/zsh"), //also Path("/usr/bin/zip")
            arguments: ["-c", zipCommand],
            //environment: T##[String : CustomStringConvertible],
            outputFilesDirectory: outputDir)
        ]
        
        //works, but problematic b/c running it creates copy resources warnings & errors e.g.
        //WARNING: Skipping duplicate build file in Copy Bundle Resources build phase: Users/.../MyPreBuildPlugin/snapshot_2024-01-17T16-29-14.zip
        //FAILURE: CpResource... error: /Users/.../MyPreBuildPlugin/snapshot_2024-01-17T16-30-04.zip: No such file or directory (in target 'PluginExplorer_plugin-tester' from project 'PluginExplorer')
        result.append(removeExcessFiles(directory: outputDir))
        
        
        return result
    }
    
    //WARNING: Only works if no spaces in file names.
    func removeExcessFiles(directory:Path) -> PackagePlugin.Command {
        let removeCommand = "cd \(directory.string) && ls -1t | tail -n +6 | xargs rm -f"
        return .prebuildCommand(displayName: "Remove Stalest",
                         executable: .init("/bin/zsh"),
                         arguments: ["-c", removeCommand],
                         outputFilesDirectory: directory
        )
    }
}
//let outputFile = context.pluginWorkDirectory.appending(["snapshot.zip"])
//return [.prebuildCommand(
//    displayName: "------------ MyPreBuildPlugin ------------",
//    executable: .init("/usr/bin/zip"), //also Path("/usr/bin/zip")
//    arguments: ["\(outputFile)", target.directory.string],
//    //environment: T##[String : CustomStringConvertible],
//    outputFilesDirectory: outputFile.removingLastComponent())
//]

//problematic because assembled at plugin build time
//func removeFile(directory:Path, file:String) -> PackagePlugin.Command {
//    .prebuildCommand(displayName: "Remove Stalest",
//                     executable: .init("/bin/rm"),
//                     arguments: [directory.appending([file]).string],
//                     outputFilesDirectory: directory
//    )
//}


//Didn't work
//        return [.prebuildCommand(
//            displayName: "Test prebuild",
//            executable: .init("usr/bin/ls"),
//            arguments: ["-lta", context.package.directory.string, ">> \(outputDir)/mylog.txt"],
//            //environment: T##[String : CustomStringConvertible],
//            outputFilesDirectory: outputDir)
//        ]
