import ArgumentParser

@main
struct PluginTesterCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "For Testing The Plugins", 
        version: "0.0.0", 
        subcommands: [hello.self, fruit_list.self], 
        defaultSubcommand: hello.self)
    
    struct hello: ParsableCommand {
    mutating func run() throws {
        print("Hello, world!")
    }
    }
}
