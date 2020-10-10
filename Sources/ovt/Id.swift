import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Id: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the ID of an app bundle specified by its path."
        )

        @Argument var appPath: String
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let id = getBundleId(from: appPath) else {
                Log.error(
                    "Cannot get bundle ID, the bundle path might be invalid."
                )
                return
            }
            print(id)
        }
    }
}
