import Foundation

let arguments = ProcessInfo().arguments
if arguments.count < 3 {
    print("missing arguments")
}
let (input, output) = (arguments[1], arguments[2])

print(input, output)

var generatedCode = """
    import Foundation
    let myVar = 3
"""

//try FileManager.default.contentsOfDirectory(atPath: input).forEach { item in
//    generatedCode.append("\n//\(item)")
//}

//print("okay, so I won't save anything.")
try generatedCode.write(to: URL(fileURLWithPath: output), atomically: true, encoding: .utf8)
