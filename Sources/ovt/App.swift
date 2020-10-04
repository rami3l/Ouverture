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
        subcommands: [Check.self, Lookup.self]
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
                "Check all the file types or URL schemes supported by a bundle."
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
            var hasOutput = false
            print("`\(bundle)` supports the following:", terminator: "\n\n")
            let tys = readSupportedFileTypesFromBundle(appDir)
            tys.map {
                hasOutput = printColumnsWithWidth(title: "File Types", $0)
            }
            let exts = readSupportedFileExtensionsFromBundle(appDir)
            exts.map {
                hasOutput = printColumnsWithWidth(title: "File Extensions", $0)
            }
            let scms = readSupportedUrlSchemesFromBundle(appDir)
            scms.map {
                hasOutput = printColumnsWithWidth(title: "URL Schemes", $0)
            }
            if !hasOutput { print("(Nothing to print)") }
        }
    }

    struct Lookup: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Look up for the app bundles which have claimed some file type or URL scheme."
        )

        @Argument var fileType: String
        @OptionGroup var options: Ovt.Options
        @Option(
            name: .shortAndLong,
            help: "Specify the parent UTI for some extension."
        ) var conformingTo: String?

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            // * Here we consider that the `fileType`s starting with a dot are extensions, eg. `.txt`,
            // * while the others are sent to the UTI handler .
            let isExt = fileType.starts(with: ".")
            let isUti = fileType.isReverseDomain()

            var hasOutput = false
            print(
                "`\(fileType)` is claimed by the following:",
                terminator: "\n\n"
            )
            let defaultHandler: CFString? = {
                /// Good old Rust match hack.
                switch () {
                case _ where isExt:
                    // Truncate the leading dot.
                    return getDefaultHandler(
                        forExt: String(fileType.dropFirst()),
                        conformingTo: conformingTo as CFString?
                    )
                case _ where isUti:
                    return getDefaultHandler(forUti: fileType as CFString)
                default:
                    // This must be a URL Scheme.
                    return getDefaultHandler(forUrlScheme: fileType as CFString)
                }
            }()
            defaultHandler.map {
                hasOutput = true
                printColumns(title: "Default Handler", [$0 as String])
            }
            let handlerCandidates: [CFString]? = {
                /// Good old Rust match hack.
                switch () {
                case _ where isExt:
                    // Truncate the leading dot.
                    return getHandlerCandidates(
                        forExt: String(fileType.dropFirst()),
                        conformingTo: conformingTo as CFString?
                    )
                case _ where isUti:
                    return getHandlerCandidates(forUti: fileType as CFString)
                default:
                    // This must be a URL Scheme.
                    return getHandlerCandidates(
                        forUrlScheme: fileType as CFString
                    )
                }
            }()
            handlerCandidates.map {
                hasOutput = printColumnsWithWidth(
                    title: "Handler Candidates",
                    $0 as [String]
                )
            }
            if !hasOutput { print("(Nothing to print)") }
        }
    }
}
