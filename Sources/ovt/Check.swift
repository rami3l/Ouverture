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
                "Check all the file types or URL schemes supported by a bundle specified by its directory."
        )

        @Argument var appDir: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let bundleId = getBundleId(from: appDir) else {
                Log.error(
                    "Cannot get bundle ID, the bundle directory might be invalid."
                )
                return
            }
            checkImpl(appDir, bundleId)
        }
    }

    struct CheckId: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Check all the file types or URL schemes supported by a bundle specified by its ID."
        )

        @Argument var bundleId: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let appUrl = getBundleUrl(from: bundleId as CFString),
                let appDir = appUrl.absoluteURL?.path
            else {
                Log.error(
                    "Cannot get bundle URL, the bundle ID might be invalid."
                )
                return
            }
            checkImpl(appDir, bundleId)
        }
    }
}

private func checkImpl(_ appDir: String, _ bundleId: String) {
    var hasOutput = false
    print("`\(bundleId)` supports the following:", terminator: "\n\n")
    let tys = readSupportedFileTypesFromBundle(appDir)
    tys.map { hasOutput = printColumnsWithWidth(title: "File Types", $0) }
    let exts = readSupportedFileExtensionsFromBundle(appDir)
    exts.map { hasOutput = printColumnsWithWidth(title: "File Extensions", $0) }
    let scms = readSupportedUrlSchemesFromBundle(appDir)
    scms.map { hasOutput = printColumnsWithWidth(title: "URL Schemes", $0) }
    if !hasOutput { print("(Nothing to print)") }
}
