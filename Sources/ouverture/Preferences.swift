import CoreServices.LaunchServices
import Foundation

enum Preferences {}

extension Preferences {
    static func getUtiString(for ext: String) -> CFString {
        return UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            ext as CFString,
            nil
        )!.takeUnretainedValue()
    }

    static func getDefault(for ext: String) -> CFString? {
        return LSCopyDefaultRoleHandlerForContentType(
            getUtiString(for: ext),
            .all
        )?.takeUnretainedValue()
    }

    static func setDefault(
        for ext: String,
        as cfBundleId: CFString
    ) -> Bool {
        return kOSReturnSuccess
            == LSSetDefaultRoleHandlerForContentType(
                getUtiString(for: ext),
                .all,
                cfBundleId
            )
    }

    static func readSupportedFileTypesFromPlist(
        dir: String,
        file: String = "Contents/Info.plist"
    ) -> [String]? {
        guard #available(macOS 10.11, *) else {
            return nil
        }

        let dir = URL.init(fileURLWithPath: dir, isDirectory: true)
        let plistUrl = URL.init(fileURLWithPath: file, relativeTo: dir)
        print("set plist to \(plistUrl.absoluteString)")

        guard
            let plistDict = Plist.readToDict(from: plistUrl.absoluteURL.path)
        else {
            print("Unable to read plist")
            return nil
        }

        guard
            let dicts = plistDict["CFBundleDocumentTypes"] as? [[String: Any]]
        else {
            print("Unable to read CFBundleDocumentTypes")
            return nil
        }

        var res = [String]()
        for dict in dicts {
            if let types = dict["LSItemContentTypes"] as? [String] {
                res.append(contentsOf: types)
            }
        }

        return res
    }
}
