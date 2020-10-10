import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Which: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the path(s) of an app bundle specified by its ID."
        )

        @Argument var bundleId: String
        @OptionGroup var options: Ovt.Options
        @Flag(name: .shortAndLong, help: "Print a single path.") var lucky =
            false

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            if lucky {
                guard let url = getBundleUrl(from: bundleId as CFString),
                    let path = url.absoluteURL?.path
                else {
                    Log.error(
                        "Cannot get bundle path, the bundle ID might be invalid."
                    )
                    return
                }
                print(path)
            }
            else {
                guard
                    let urls = getBundleUrlCandidates(
                        from: bundleId as CFString
                    )
                else {
                    Log.error(
                        "Cannot get bundle path, the bundle ID might be invalid."
                    )
                    return
                }
                let paths = urls.map({ $0.absoluteURL!.path })
                paths.forEach { print($0) }
            }
        }
    }
}
