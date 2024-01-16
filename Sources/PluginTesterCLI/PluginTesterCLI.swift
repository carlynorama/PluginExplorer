import ArgumentParser

@main
struct PluginTesterCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "For Testing The Plugins", 
        version: "0.0.0", 
        subcommands: [hello.self], 
        defaultSubcommand: hello.self)
    
    struct hello: ParsableCommand {
    mutating func run() throws {
        print("Hello, world!")
    }
    }
}


extension PluginTesterCLI {
    struct fruit_list: ParsableCommand {
        mutating func run() throws {
            print("Hello, fruitName!")
        }
    }
}

protocol Fruit {
    var name:String {get}
}

struct Apple:Fruit {
    let name:String
}

struct Banana:Fruit {
    let name:String
}
