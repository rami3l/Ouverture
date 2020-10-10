import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Uti: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Utilities for handling UTIs.",
            subcommands: [
                FromExt.self, ToExt.self, Parent.self, Describe.self,
            ],
            defaultSubcommand: FromExt.self
        )
    }
}

extension Ovt.Uti {
    struct FromExt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the UTI of a file extension."
        )

        @Argument var ext: String
        @OptionGroup var options: Ovt.Options
        @Option(
            name: .shortAndLong,
            help: "Specify the parent UTI for the file extension."
        ) var conformingTo: String?

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            let ext_ = ext.starts(with: ".") ? String(ext.dropFirst()) : ext
            guard
                let id = getUtiString(
                    forExt: ext_,
                    conformingTo: conformingTo as CFString?
                ) as String?
            else {
                Log.error(
                    "Cannot get UTI, the file extension might be invalid."
                )
                return
            }
            let _ = printColumnsWithWidth(
                title: "Preferred UTI for `.\(ext_)`",
                [id]
            )
        }
    }

    struct ToExt: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the possible extension(s) of a UTI."
        )

        @Argument var uti: String
        @OptionGroup var options: Ovt.Options
        @Flag(name: .shortAndLong, help: "Print a single extension.")
        var lucky = false

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard
                let exts = getUtiExtensions(forUti: uti as CFString)
                    as [String]?, !exts.isEmpty,
                printColumnsWithWidth(
                    title: "Extension(s) for `\(uti)`",
                    lucky ? [exts[0]] : exts
                )
            else {
                print("(Nothing to print)")
                return
            }
        }
    }

    struct Parent: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the parent(s) of a UTI."
        )

        @Argument var uti: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard
                let parents = getUtiParents(forUti: uti as CFString)
                    as [String]?, !parents.isEmpty,
                printColumnsWithWidth(title: "Parent(s) for `\(uti)`", parents)
            else {
                print("(Nothing to print)")
                return
            }
        }
    }

    struct Describe: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the description string of a UTI."
        )

        @Argument var uti: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard
                let desc = getUtiDescription(forUti: uti as CFString)
                    as String?,
                printColumnsWithWidth(title: "Description for `\(uti)`", [desc])
            else {
                print("(Nothing to print)")
                return
            }
        }
    }
}
