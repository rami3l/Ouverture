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
            help: "Specify the parent UTI for some extension."
        ) var conformingTo: String?

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)

            var hasOutput = false
            print(
                "`\(fileType)` is claimed by the following:",
                terminator: "\n\n"
            )

            // * Here we consider that the `fileType`s starting with `.` are extensions, eg. `.txt`,
            // * those ending with `://` are URL schemes,
            // * while the reverse domain names are UTIs.
            // * The fallback case is extension, eg.`txt`.
            let isExt = fileType.starts(with: ".")
            let isScm = fileType.hasSuffix("://")
            let isUti = fileType.isReverseDomain()
            let defaultHandler: CFString? = {
                /// Good old Rust match hack.
                switch () {
                case _ where isExt:
                    // Truncate the leading dot.
                    let ext = String(fileType.dropFirst())
                    return getDefaultHandler(
                        forExt: ext,
                        conformingTo: conformingTo as CFString?
                    )
                case _ where isScm:
                    // Truncate the suffix `://`.
                    let scm = fileType.prefix(while: { $0 != ":" })
                    return getDefaultHandler(forUrlScheme: scm as CFString)
                case _ where isUti:
                    return getDefaultHandler(forUti: fileType as CFString)
                default:
                    return getDefaultHandler(
                        forExt: fileType,
                        conformingTo: conformingTo as CFString?
                    )
                }
            }()
            defaultHandler.map {
                hasOutput = true
                printColumns(title: "Default Handler", [$0 as String])
            }

            let handlerCandidates: [CFString]? = {
                switch () {
                case _ where isExt:
                    // Truncate the leading dot.
                    let ext = String(fileType.dropFirst())
                    return getHandlerCandidates(
                        forExt: ext,
                        conformingTo: conformingTo as CFString?
                    )
                case _ where isScm:
                    // Truncate the suffix `://`.
                    let scm = fileType.prefix(while: { $0 != ":" })
                    return getHandlerCandidates(forUrlScheme: scm as CFString)
                case _ where isUti:
                    return getHandlerCandidates(forUti: fileType as CFString)
                default:
                    return getHandlerCandidates(
                        forExt: fileType,
                        conformingTo: conformingTo as CFString?
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
