import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Lookup: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Look up for the app bundles which have claimed some file type or URL scheme."
        )

        @Argument var fileType: String
        @OptionGroup var options: Ovt.Options
        @Option(
            name: .shortAndLong,
            help: "Specify the parent UTI for the file extension."
        ) var conformingTo: String?

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            let fileType_ = FileType(fileType)
            print(
                "`\(fileType_)` is claimed by the following:",
                terminator: "\n\n"
            )
            var hasOutput = false

            let defaultHandler: CFString? = {
                switch fileType_ {
                case let .ext(x):
                    return getDefaultHandler(
                        forExt: x,
                        conformingTo: conformingTo as CFString?
                    )
                case let .urlScheme(s):
                    return getDefaultHandler(forUrlScheme: s as CFString)
                case let .uti(u):
                    return getDefaultHandler(forUti: u as CFString)
                }
            }()
            defaultHandler.map {
                hasOutput = true
                printColumns(title: "Default Handler", [$0 as String])
            }

            let handlerCandidates: [CFString]? = {
                switch fileType_ {
                case let .ext(x):
                    return getHandlerCandidates(
                        forExt: x,
                        conformingTo: conformingTo as CFString?
                    )
                case let .urlScheme(s):
                    return getHandlerCandidates(forUrlScheme: s as CFString)
                case let .uti(u):
                    return getHandlerCandidates(forUti: u as CFString)
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
