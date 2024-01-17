import Foundation

let arguments = ProcessInfo().arguments
if arguments.count < 3 {
    print("missing arguments")
}

let (inputDir, outputDir, outputFile) = (arguments[1], arguments[2], arguments[3])

print(inputDir)
print(outputDir)

var output = URL(fileURLWithPath: outputDir)
output.append(component: outputFile)

var generatedCode = generateHeader()
var fruitStoreCode = "\n\nvar FruitStore:Dictionary<String,[any Fruit]> = ["

let directoryURL = URL(filePath: inputDir)
try FileManager.default.contentsOfDirectory(atPath: inputDir).forEach { item in
    //The build tool does have a source file type check, but have not
    //checked if excluded folders would even get examined.
    guard item.suffix(4)==".txt" else {
        return
    }
    let fileUrl = directoryURL.appending(component: item) 
    //fileUrl.checkPromisedItemIsReachable()
    
    let extIndex = item.lastIndex(of: ".")
    let base = item.prefix(upTo: extIndex!)
    let structName = base.capitalized
    generatedCode.append(generateStruct(structName: structName))
    print("LOOK HERE!!!!!!!!!!!!", fileUrl) //<== WHERE DOES THIS GO??
    let fruits = try String(contentsOf: fileUrl).split(separator: "\n")
    
    fruitStoreCode.append(generateAddToFruitStore(base: base, structName: structName, fruitList: fruits))
    
}

fruitStoreCode.append("\n]")
generatedCode.append(fruitStoreCode)

//print("okay, so I won't save anything.")
try generatedCode.write(to: output, atomically: true, encoding: .utf8)

func generateHeader() -> String {
        """
        import Foundation
        import ArgumentParser
        
        let testVariable = "hello"
        
        """
}

func generateStruct(structName:some StringProtocol) -> String {
    """
    \n
    struct \(structName):Fruit {
        let name:String
    }
    """
}

func generateAddToFruitStore(base:some StringProtocol, structName:some StringProtocol, fruitList:[some StringProtocol]) -> String {
     let initStrings = fruitList.map { "\(structName)(name:\"\($0.capitalized)\")" }
     let fruitArrayCode = "[\(initStrings.joined(separator: ","))]"
    //FruitStore[\"\(base)\"] = \(fruitArrayCode)
     return
"""
     \n     "\(base)\":\(fruitArrayCode),
"""
}
