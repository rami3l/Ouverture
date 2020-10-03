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
        subcommands: [
            Check.self  // Multiply.self, Statistics.self
        ]
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

extension Ovt {
    struct Check: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Check the file types and URL schemes supported by a bundle."
        )

        @Argument var appDir: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let bundle = getBundleId(from: appDir) else {
                Log.error(
                    "Cannot get bundle ID, the bundle directory might be invalid"
                )
                return
            }
            var nothing = true
            print("`\(bundle)` supports the following:", terminator: "\n\n")
            let tys = readSupportedFileTypesFromBundle(appDir)
            if tys != nil {
                nothing = false
                printColumns(title: "File Types", tys!)
            }
            let exts = readSupportedFileExtensionsFromBundle(appDir)
            if exts != nil {
                nothing = false
                printColumns(title: "File Extensions", exts!)
            }
            let scms = readSupportedUrlSchemesFromBundle(appDir)
            if scms != nil {
                nothing = false
                printColumns(title: "URL Schemes", scms!)
            }
            if nothing { print("(Nothing to print)") }
        }
    }
}
