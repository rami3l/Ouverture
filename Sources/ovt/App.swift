import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

struct Ovt: ParsableCommand {
    static var version = "0.1.0"

    static var configuration = CommandConfiguration(
        abstract: "A default application modifier for macOS.",
        version: version,
        subcommands: [
            Bind.self, Check.self, Id.self, Lookup.self, Which.self, Uti.self,
        ]
    )
}

extension Ovt {
    /// The common options across subcommands.
    struct Options: ParsableArguments {
        @Flag(name: .shortAndLong, help: "Enable verbose output.")
        var verbose = false
    }
}
