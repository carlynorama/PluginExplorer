//
//  ScreamIntoTheVoid.swift
//
//
//  Created by Carlyn Maw on 1/17/24.
//


import PackagePlugin
import Foundation

@main
struct ScreamIntoTheVoid:BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        
        //return [echoTest(toEcho: "HHHHEEEEELLLLLLOOOOOO!!!! AAAAAAAAAAAAAAAAAAAAAAAAAAAAHAHHHHAHAHAHAHAHAHAHAHAHAHHHAHHHHHHHHHHHAAAAHHH", outputDir:context.pluginWorkDirectory)]
        
        var result:[PackagePlugin.Command] = [echoTest(toEcho: "HHHHEEEEELLLLLLOOOOOO!!!! AAAAAAAAAAAAAAAAAAAAAAAAAAAAHAHHHHAHAHAHAHAHAHAHAHAHAHHHAHHHHHHHHHHHAAAAHHH", outputDir:context.pluginWorkDirectory)]
        
        print("from SITV:", target.directory.removingLastComponent())
        print("from SITV:", context.pluginWorkDirectory.appending("file_log.txt"))
        result.append(logDirectoryContents(toLog: target.directory.removingLastComponent(), output: context.pluginWorkDirectory.appending("file_log.txt")))
                
        return result
        
    }
    
    func echoTest(toEcho:some StringProtocol, outputDir:Path) -> PackagePlugin.Command {
        .prebuildCommand(
            displayName: "YEEELLLLLLLLLLLIIIIIIIIINNNNGGG",
            executable: .init("/bin/zsh"),
            arguments: ["-c", "echo \(toEcho)"],
            outputFilesDirectory: outputDir
        )
    }
    
    
    func logDirectoryContents(toLog:Path, output:Path) -> PackagePlugin.Command {
        .prebuildCommand(
            displayName: "Results from ls",
            executable: .init("/bin/ls"),
            arguments: ["-1t", toLog.string],//, ">>", "\(output)" ],
            //arguments: ["-1t", output.removingLastComponent().string],
            //environment: T##[String : CustomStringConvertible],
            outputFilesDirectory: output.removingLastComponent()
        )
    }
}
  


//Didn't work, no error but no output file appears. Where do errors go in Xcode
//        return [.prebuildCommand(
//            displayName: "Test prebuild",
//            executable: .init("usr/bin/ls"),
//            arguments: ["-lta", context.package.directory.string, ">> \(outputDir)/mylog.txt"],
//            //environment: T##[String : CustomStringConvertible],
//            outputFilesDirectory: outputDir)
//        ]
