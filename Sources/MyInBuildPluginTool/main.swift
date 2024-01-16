import Foundation

let arguments = ProcessInfo().arguments
if arguments.count < 3 {
    print("missing arguments")
}
let structName = arguments[1]
let (input, output) = (arguments[2], arguments[3])

print(input, output)

var generatedCode = generateCode(structName: structName)

//try FileManager.default.contentsOfDirectory(atPath: input).forEach { item in
//    generatedCode.append("\n//\(item)")
//}

//print("okay, so I won't save anything.")
try generatedCode.write(to: URL(fileURLWithPath: output), atomically: true, encoding: .utf8)


func generateCode(structName:String) -> String {
    """
    import Foundation
    import ArgumentParser
    
    
    
    """
}
