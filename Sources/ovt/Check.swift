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
}
