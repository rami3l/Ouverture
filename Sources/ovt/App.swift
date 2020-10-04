import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

struct Ovt: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A default application modifier for macOS.",
        // defaultSubcommand: Add.self,
        subcommands: [Check.self, CheckId.self, Lookup.self, Which.self]
    )
}

extension Ovt {
    /// The common options across subcommands
    struct Options: ParsableArguments {
        @Flag(name: .shortAndLong, help: "Enable verbose output.") var verbose =
            false
        /*
        @Argument(help: "A group of integers to operate on.")
        var values: [Int]
        */
    }
}
