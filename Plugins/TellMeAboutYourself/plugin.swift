//
//  TellMeAboutYourself/plugin.swift
//
//
//  Created by Carlyn Maw on 1/14/24.
//

//Print statements can be found in build log in Xcode in "Package" section.

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
        message.append("\nargument extractor:\(argExtractor)")
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
        
        message.append("\n\nSwift Source Files")
        let packageDir = context.package.directory.lastComponent
        for target in targets {
            //let targetDir = target.directory.lastComponent
            if let sourceList = target.sourceModule?.sourceFiles(withSuffix: ".swift") {
                sourceList.forEach({ sourceFile in
                    let fullPath = sourceFile.path.string
                    let range = fullPath.firstRange(of: "\(packageDir)")
                    //if used .name instead of .directory.lastComponent
                    //would need this redundancy for sure. probably overkill here.
                    let pathStart = range?.lowerBound ?? fullPath.startIndex
                    let relativePath = fullPath.suffix(from: pathStart)
                    message.append("\n\(relativePath) \ttype:\(sourceFile.type)")
                })
            }
        }
        
        message.append("\n\n\n--------------------------------------------------------------------")
        message.append("\nDUMPS\n")
        
        //message.append("\(context)")
        //message.append("\nsourceModules: \(context.package.sourceModules)")
        //message.append("\nproducts:\(context.package.products)")
        //message.append("\ntargets:\(context.package.targets)")
        
        //let sources = targets.map({ $0.sourceModule?.sourceFiles })
        //message.append("\n\nsourceFiles:\(sources)")
        
        let location = context.package.directory.appending([fileName])
        try writeToFile(location: location, content: message)
    }
    
    func writeToFile(location:Path, content:some StringProtocol) throws {
        try content.write(toFile: location.string, atomically: true, encoding: .utf8)
    }
}


#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension TellMeAboutYourself: XcodeCommandPlugin {
    func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
   
        
        let fileName = "WhatThePluginSees" + ".txt"
        
        var message = "Arguments Info"
        message.append("\narguments:\(arguments)")
        var argExtractor = ArgumentExtractor(arguments)
        message.append("\nargument extractor:\(argExtractor)")
        let targetNames = argExtractor.extractOption(named: "target")
        message.append("\nextracted names:\(targetNames)")
        
        message.append("\n\nContext Info")
        message.append("\nworkDirectory: \(context.pluginWorkDirectory)")
        
        message.append("\n\nPackage Info")
        message.append("\nNot available in XCode")
        
        message.append("\n\nXodeProject Info")
        let project = context.xcodeProject
        
        message.append("\ndirectory: \(context.xcodeProject.directory)")
        
        message.append("\nfilePaths: \(context.xcodeProject.filePaths)")
        message.append("\nall targets:\(context.xcodeProject.targets.map({$0.displayName}))")
        
        //Nope. No plugins in here.
        let targets = context.xcodeProject.targets
        let targetDirectories = targets.map({"\n\($0.displayName) of type \(String(describing: $0.product))"})
        for dir in targetDirectories {
            message.append(dir)
        }
        
        message.append("\n\nSwift Source Files")
        let packageDir = context.xcodeProject.directory.lastComponent
        for target in targets {
            //let targetDir = target.directory.lastComponent
               let sourceList = target.inputFiles.filter({$0.type == .source})
                sourceList.forEach({ sourceFile in
                    let fullPath = sourceFile.path.string
                    let range = fullPath.firstRange(of: "\(packageDir)")
                    let pathStart = range?.lowerBound ?? fullPath.startIndex
                    let relativePath = fullPath.suffix(from: pathStart)
                    message.append("\n\(relativePath) \ttype:\(sourceFile.type)")
                })
        
        }
        
        
        
        message.append("\n\n\n--------------------------------------------------------------------")
        message.append("\nDUMPS\n")
        
        //message.append("\(context)")
        
        let location = context.xcodeProject.directory.appending([fileName])
        try writeToFile(location: location, content: message)
    }
    
}

#endif
