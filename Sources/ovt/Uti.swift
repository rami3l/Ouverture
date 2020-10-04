import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Uti: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Get the UTI of an file extension."
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
                )
            else {
                Log.error(
                    "Cannot get UTI, the file extension might be invalid."
                )
                return
            }
            print(id)
        }
    }
}
