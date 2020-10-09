import ArgumentParser
import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import Ouverture

extension Ovt {
    struct Bind: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract:
                "Make an app bundle the default handler for some file type or URL scheme.",
            subcommands: [Path.self, Id.self],
            defaultSubcommand: Path.self
        )
    }
}

extension Ovt.Bind {
    struct Path: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Bind a bundle by its path."
        )

        @Argument var appPath: String
        @Argument var fileType: String
        @Option(
            name: .shortAndLong,
            help: "Specify the parent UTI for the file extension."
        ) var conformingTo: String?
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            guard let bundleId = getBundleId(from: appPath) else {
                Log.error(
                    "Cannot get bundle ID, the bundle directory might be invalid."
                )
                return
            }
            bindImpl(fileType, conformingTo, bundleId)
        }
    }

    struct Id: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Bind a bundle by its ID."
        )

        @Argument var bundleId: String
        @Argument var fileType: String
        @Option(
            name: .shortAndLong,
            help: "Specify the parent UTI for the file extension."
        ) var conformingTo: String?
        @OptionGroup var options: Ovt.Options

        mutating func run() {
            loggerInit(self.options.verbose ? .verbose : .info)
            bindImpl(fileType, conformingTo, bundleId)
        }
    }
}

private func bindImpl(
    _ fileType: String,
    _ conformingTo: String?,
    _ bundleId: String
) {
    let fileType_ = FileType(fileType)
    print(
        "Setting the default handler for `\(fileType)` to `\(bundleId)`"
    )
    let success: Bool = {
        let bundleId_ = bundleId as CFString
        switch fileType_ {
        case let .ext(x):
            return setDefaultHandler(
                forExt: x,
                conformingTo: conformingTo as CFString?,
                to: bundleId_
            )
        case let .urlScheme(s):
            return setDefaultHandler(
                forUrlScheme: s as CFString,
                to: bundleId_
            )
        case let .uti(u):
            return setDefaultHandler(
                forUti: u as CFString,
                to: bundleId_
            )
        }
    }()
    print(
        success ? "Done." : "Failed."
    )
}
