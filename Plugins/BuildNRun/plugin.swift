//
//  BuildNRun/plugin.swift
//
//
//  Created by Carlyn Maw on 1/14/29.
//

// This is a starting point for a command plugin that could be customized for a specific package.

import PackagePlugin
import Foundation

@main
struct BuildNRun: CommandPlugin {
    // Entry point for command plugins applied to Swift Packages.
    func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {

        //DO WORK
        
        //Hard Coded Desired Target
        let targetToRunName = "DemoFruitStore"
        let arguments = ["fruit_list", "citrus"]
        
        let parameters = PackageManager.BuildParameters()
        //parameters.logging = printCommands ? .verbose : .concise
        //parameters.configuration = release ? .release : .debug
        //print(parameters)
        
        //------------------------------------  STYLE ONE
        //rebuilds EVERYBODY, result has all the artifacts from every
        //plugin, etc.
        let result = try packageManager.build(.all(includingTests: false), parameters: parameters)
        print(result.logText)
        print("-----------")
        print(result.builtArtifacts)
        if result.succeeded {
            if let resultToRun = result.builtArtifacts.first(where: {
                $0.kind == .executable && $0.path.lastComponent == targetToRunName
            }) {
                let message = try runProcess(URL(fileURLWithPath: resultToRun.path.string), arguments: arguments)
                print(message)
            }
        }
        
        //------------------------------------  END STYLE ONE
        
        //------------------------------------  STYLE TWO
        //the .build() function can also filter on product.
        //Does not rebuild plugins, etc.
        
        let targets = try context.package.targets(named: [targetToRunName])
        
       let targetsToRun = try targets.flatMap {
           try extractRunnableTargets($0, parameters: parameters)
        }
        
       try targetsToRun.forEach { targetToRun in
            let message = try runProcess(URL(fileURLWithPath: targetToRun.path.string), arguments: arguments)
            print(message)
        }
        
        //------------------------------------  END STYLE TWO
    }
    
    func extractRunnableTargets(_ target:Target, parameters:PackageManager.BuildParameters) throws -> [PackageManager.BuildResult.BuiltArtifact] {
        print("trying for target... \(target.name)")
        let result = try packageManager.build(.target(target.name), parameters: parameters)
        print(result.logText)
        if result.succeeded  {
           return result.builtArtifacts.filter({$0.kind == .executable })
        } else {
            return []
        }
        
    }
}

@discardableResult
func runProcess(_ tool:URL, arguments:[String] = [], workingDirectory:URL? = nil) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = arguments
    
    if let workingDirectory {
        task.currentDirectoryURL = workingDirectory
    }
    //task.qualityOfService
    //task.environment

    task.standardInput = nil
    task.executableURL = tool
    try task.run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    task.waitUntilExit()

    if task.terminationStatus == 0 || task.terminationStatus == 2 {
      return output
    } else {
      print(output)
      throw CustomProcessError.unknownError(exitCode: task.terminationStatus)
    }
}

enum CustomProcessError: Error {
  case unknownError(exitCode: Int32)
}



//
        
//         let packageDirectory = context.package.directory
//        let command = "cd \(packageDirectory); ls; swift run"
//        let result = try shellOneShot(command)
//
////        let packageDirectoryURL = URL(fileURLWithPath: packageDirectory.string)
////
////        let result = try runIt(packageDirectoryURL)
//
//
////MARK: Shell Caller
//@discardableResult
//func shellOneShot(_ command: String) throws -> String {
//    let task = Process()
//    let pipe = Pipe()
//    
//    task.standardOutput = pipe
//    task.standardError = pipe
//    task.arguments = ["-c", command]
//    
//    //task.currentDirectoryURL
//    //task.qualityOfService
//    //task.environment
//    
//    task.standardInput = nil
//    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
//    try task.run()
//    
//    let data = pipe.fileHandleForReading.readDataToEndOfFile()
//    let output = String(data: data, encoding: .utf8)!
//    
//    task.waitUntilExit()
//
//    if task.terminationStatus == 0 || task.terminationStatus == 2 {
//      return output
//    } else {
//      print(output)
//      throw CommandError.unknownError(exitCode: task.terminationStatus)
//    }
//    
//    
//}
//
//
//
//#if canImport(XcodeProjectPlugin)
//import XcodeProjectPlugin
//
//extension ShellCommand: XcodeCommandPlugin {
//    // Entry point for command plugins applied to Xcode projects.
//    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
//        print("Hello, World!")
//    }
//}
//
//#endif
