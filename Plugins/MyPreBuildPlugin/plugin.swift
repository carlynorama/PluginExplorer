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
        
        //allowed for sandbox
        let outputDir = context.pluginWorkDirectory
        //not allowed for sandbox
        //let outputDir = context.package.directory.appending(["Storage"])
        //let outputDir = Path("/Users/{---}/")
        
        
        //let inputDir = Path("/Users/{---}/TestZipFolder")
        let inputDir = target.directory
        print("from MPBP:", outputDir)
        let result:[PackagePlugin.Command] =  [ zipFileCommand(outputDir: outputDir, folderToZip: inputDir)]
        
        print("From MPBP: to zip \(inputDir)")
        
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
    
    
    func zipFileCommand(outputDir:Path, folderToZip:Path) -> PackagePlugin.Command {
        let parentDirectory = folderToZip.removingLastComponent().string
        let folderOnly = folderToZip.lastComponent
        let zipNCleanCommand = "cd \(parentDirectory) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folderOnly) && cd - && cd \(outputDir) && ls -1t | tail -n +6 | xargs rm -f"
        //let zipCommand = "cd \(target.directory.removingLastComponent().string) && zip -r \(outputDir)/snapshot_$(date +'%Y-%m-%dT%H-%M-%S').zip \(folder)"
        
        return .prebuildCommand(
            displayName: "------------ MyPreBuildPlugin ------------",
            executable: .init("/bin/zsh"), //also Path("/bin/zsh")
            arguments: ["-c", zipNCleanCommand],
            //environment: [:], manually clearing the environment did not help
            outputFilesDirectory: outputDir)
        
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


#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension MyPreBuildPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let outputDir = context.pluginWorkDirectory//xcodeProject.directory.removingLastComponent().appending(["Storage"])
        let folderToZip = context.xcodeProject.directory.appending([target.displayName])//package.directory.appending(["Storage"])

       print("from MPBP:", outputDir)
       return [ zipFileCommand(outputDir: outputDir, folderToZip: folderToZip)]
    }
}

#endif



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



