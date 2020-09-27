import CoreServices.LaunchServices
import Foundation
import LoggerAPI

enum Preferences {}

extension Preferences {
    static func getUtiString(for ext: String) -> CFString? {
        let res = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            ext as CFString,
            nil
        )?.takeUnretainedValue()
        Log.verbose("The preferred UTI for extention `\(ext) is `\(res as String? ?? "Unknown")`")
        return res
    }

    static func getDefault(for ext: String) -> CFString? {
        guard let uti = getUtiString(for: ext) else { return nil }
        let res = LSCopyDefaultRoleHandlerForContentType(uti, .all)?.takeUnretainedValue()
        Log.verbose("The default handler for extention `\(ext) is `\(res as String? ?? "Unknown")`")
        return res
    }

    static func setDefault(
        for ext: String,
        as cfBundleId: CFString
    ) -> Bool {
        Log.verbose("Setting default handler for extention `\(ext) to `\(cfBundleId)`")
        guard let uti = getUtiString(for: ext) else { return false }
        let res =
            kOSReturnSuccess
            == LSSetDefaultRoleHandlerForContentType(uti, .all, cfBundleId)
        Log.verbose("Setting default handler " + (res ? "success" : "failed"))
        return res
    }

    static func readSupportedFileTypesFromPlist(
        fromApp appDir: String,
        file: String = "Contents/Info.plist"
    ) -> [String]? {
        guard #available(macOS 10.11, *) else { return nil }

        Log.verbose("Getting supported file types for \(appDir)")
        let appUrl = URL.init(fileURLWithPath: appDir, isDirectory: true)
        let plistUrl = URL.init(fileURLWithPath: file, relativeTo: appUrl)

        let plistAbsPath = plistUrl.absoluteURL.path
        Log.verbose("Reading plist at \(plistAbsPath)")

        guard
            let plistDict = Plist.readToDict(from: plistAbsPath)
        else {
            Log.error("Unable to read plist at \(plistAbsPath)")
            return nil
        }

        guard
            let dicts = plistDict["CFBundleDocumentTypes"] as? [[String: Any]]
        else {
            Log.error("Unable to read `CFBundleDocumentTypes` from plist")
            return nil
        }

        var res = [String]()
        for dict in dicts {
            if let types = dict["LSItemContentTypes"] as? [String] {
                res.append(contentsOf: types)
            }
        }

        Log.verbose("Got supported file types: \n\(res)")
        return res
    }
}
