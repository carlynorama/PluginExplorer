//
//  TellMeAboutYourself/plugin.swift
//
//
//  Created by Carlyn Maw on 1/14/24.
//

import PackagePlugin
import Foundation


@main
struct TellMeAboutYourself: CommandPlugin {
    func performCommand(context: PackagePlugin.PluginContext,
                        arguments: [String]) async throws {
        
        let fileName = "WhatThePluginSees" + ".txt"
        
        var message = "Arguments Info"
        message.append("\narguments:\(arguments)")
        var argExtractor = ArgumentExtractor(arguments)
        let targetNames = argExtractor.extractOption(named: "target")
        message.append("\nextracted names:\(targetNames)")
        
        message.append("\n\nContext Info")
        message.append("\nworkDirectory: \(context.pluginWorkDirectory)")
        
        message.append("\n\nPackage Info")
        message.append("\norigin: \(context.package.origin)")
        message.append("\ndirectory: \(context.package.directory)")
        
        message.append("\nproducts:\(context.package.products.map({$0.name}))")
        message.append("\nall targets:\(context.package.targets.map({$0.name}))")
        
        //https://github.com/apple/swift-package-manager/blob/4b7ee3e328dc8e7bec33d4d5d401d37abead6e41/Sources/PackageModel/Target/PluginTarget.swift#L13
        //Cannot find 'PluginTarget' in scope
        //SwiftSourceModuleTarget.self does work.
        //let specialTargets = context.package.targets(ofType: PluginTarget.self)
        
        //Nope. No plugins in here.
        let targets = context.package.targets
        //FWIW not even if you asked for them explicitly.
        //let targets = try context.package.targets(named: targetNames)
        let targetDirectories = targets.map({"\ndirectory for \($0.name): \($0.directory)"})
        for dir in targetDirectories {
            message.append(dir)
        }
        message.append("\n\n\n--------------------------------------------------------------------")
        message.append("\nFULL DUMP")
        message.append("\nsourceModules: \(context.package.sourceModules)")
        message.append("\nproducts:\(context.package.products)")
        message.append("\ntargets:\(context.package.targets)")
        
        
        
        var location = context.package.directory.appending([fileName])
        try writeToFile(location: location, content: message)
    }
    
    func writeToFile(location:Path, content:some StringProtocol) throws {
        try content.write(toFile: location.string, atomically: true, encoding: .utf8)
    }
}

