import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Check: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Check all the file types or URL schemes supported by a bundle.",
            subcommands: [Path.self, Id.self],
            defaultSubcommand: Path.self
        )
    }
}

extension Ovt.Check {
    struct Path: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Check a bundle by its path."
        )

        @Argument var appPath: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let bundleId = getBundleId(from: appPath) else {
                Log.error(
                    "Cannot get bundle ID, the bundle directory might be invalid."
                )
                return
            }
            checkImpl(appPath, bundleId)
        }
    }

    struct Id: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Check a bundle by its ID."
        )

        @Argument var bundleId: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let appUrl = getBundleUrl(from: bundleId as CFString),
                let appPath = appUrl.absoluteURL?.path
            else {
                Log.error(
                    "Cannot get bundle URL, the bundle ID might be invalid."
                )
                return
            }
            checkImpl(appPath, bundleId)
        }
    }
}

private func checkImpl(_ appPath: String, _ bundleId: String) {
    var hasOutput = false
    print("`\(bundleId)` supports the following:", terminator: "\n\n")
    let tys = readSupportedFileTypesFromBundle(appPath)
    tys.map { hasOutput = printColumnsWithWidth(title: "File Types", $0) }
    let exts = readSupportedFileExtensionsFromBundle(appPath)
    exts.map { hasOutput = printColumnsWithWidth(title: "File Extensions", $0) }
    let scms = readSupportedUrlSchemesFromBundle(appPath)
    scms.map { hasOutput = printColumnsWithWidth(title: "URL Schemes", $0) }
    if !hasOutput { print("(Nothing to print)") }
}
