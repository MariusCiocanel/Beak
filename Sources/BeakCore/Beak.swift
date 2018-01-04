import Foundation
import PathKit
import SourceKittenFramework
import SwiftShell
import Utility
import Basic

public struct BeakOptions {

    public let cachePath: Path
    public let packageName: String

    public init(cachePath: Path = "~/Documents/beak/builds", packageName: String = "BeakFile") {
        self.cachePath = cachePath.normalize()
        self.packageName = packageName
    }
}

public class Beak {

    public let version: String = "0.1.0"
    public let options: BeakOptions

    public init(options: BeakOptions) {
        self.options = options
    }

    public func execute(arguments: [String]) throws {

        let parser = ArgumentParser(commandName: "beak", usage: "[subcommand] [--path]", overview: "Beak can inspect and run functions in your swift scripts")

        let commands = [
            "list": ListCommand(options: options, parentParser: parser),
            "function": FunctionCommand(options: options, parentParser: parser),
            "run": RunCommand(options: options, parentParser: parser),
            "edit": EditCommand(options: options, parentParser: parser),
            "version": VersionCommand(options: options, parentParser: parser, version: version),
        ]

        let parsedArguments = try parser.parse(arguments)
        if let subParser = parsedArguments.subparser(parser),
            let command = commands[subParser] {
            try command.execute(parsedArguments: parsedArguments)
        } else {
            parser.printUsage(on: stdoutStream)
        }
        return
    }
}
