import CoreServices.LaunchServices
import Foundation
import LoggerAPI

enum Preferences {}

extension Preferences {
    static func getUtiString(
        forExt ext: String,
        conformingTo parentUti: CFString? = nil
    ) -> CFString? {
        let res = UTTypeCreatePreferredIdentifierForTag(
            kUTTagClassFilenameExtension,
            ext as CFString,
            parentUti
        )?
        .takeUnretainedValue()
        Log.verbose(
            "The preferred UTI for extention `\(ext)` is `\(res as String? ?? "Unknown")`"
        )
        return res
    }

    static func getDefault(forUti uti: CFString) -> CFString? {
        let res = LSCopyDefaultRoleHandlerForContentType(uti, .all)?
            .takeUnretainedValue()
        Log.verbose(
            "The default handler for UTI `\(uti)` is `\(res as String? ?? "Unknown")`"
        )
        return res
    }

    static func getDefault(
        forExt ext: String,
        conformingTo parentUti: CFString? = nil
    ) -> CFString? {
        guard let uti = getUtiString(forExt: ext, conformingTo: parentUti)
        else { return nil }
        return getDefault(forUti: uti)
    }

    static func getDefault(forUrlScheme urlScheme: CFString) -> CFString? {
        let res = LSCopyDefaultHandlerForURLScheme(urlScheme)?
            .takeUnretainedValue()
        Log.verbose(
            "The default handler for URL Scheme `\(urlScheme)` is `\(res as String? ?? "Unknown")`"
        )
        return res
    }

    static func getCandidates(forUti uti: CFString) -> [CFString]? {
        let res =
            LSCopyAllRoleHandlersForContentType(uti, .all)?
            .takeUnretainedValue() as? [CFString]
        Log.verbose(
            "The handler candidates for UTI `\(uti)` is:\n`\(String(describing: res))`"
        )
        return res
    }

    static func getCandidates(
        forExt ext: String,
        conformingTo parentUti: CFString? = nil
    ) -> [CFString]? {
        guard let uti = getUtiString(forExt: ext, conformingTo: parentUti)
        else { return nil }
        return getCandidates(forUti: uti)
    }

    static func getCandidates(forUrlScheme urlScheme: CFString) -> [CFString]? {
        let res =
            LSCopyAllHandlersForURLScheme(urlScheme)?.takeUnretainedValue()
            as? [CFString]
        Log.verbose(
            "The handler candidates for URL Scheme `\(urlScheme)` is:\n`\(String(describing: res))`"
        )
        return res
    }

    static func setDefault(forUti uti: CFString, to cfBundleId: CFString)
        -> Bool
    {
        Log.verbose(
            "Setting default handler for UTI `\(uti) to `\(cfBundleId)`"
        )
        let res =
            kOSReturnSuccess
            == LSSetDefaultRoleHandlerForContentType(uti, .all, cfBundleId)
        Log.verbose("Setting default handler " + (res ? "success" : "failed"))
        return res
    }

    static func setDefault(
        forExt ext: String,
        conformingTo parentUti: CFString? = nil,
        to cfBundleId: CFString
    ) -> Bool {
        Log.verbose(
            "Setting default handler for extention `\(ext) to `\(cfBundleId)`"
        )
        guard let uti = getUtiString(forExt: ext, conformingTo: parentUti)
        else { return false }
        return setDefault(forUti: uti, to: cfBundleId)
    }

    static func setDefault(
        forUrlScheme urlScheme: CFString,
        to cfBundleId: CFString
    ) -> Bool {
        Log.verbose(
            "Setting default handler for URL Scheme `\(urlScheme) to `\(cfBundleId)`"
        )
        let res =
            kOSReturnSuccess
            == LSSetDefaultHandlerForURLScheme(urlScheme, cfBundleId)
        Log.verbose("Setting default handler " + (res ? "success" : "failed"))
        return res
    }

    static func readInfoFromBundle(
        _ appDir: String,
        file: String = "Contents/Info.plist",
        key: String,
        subkey: String
    ) -> Set<String>? {
        guard #available(macOS 10.11, *) else {
            Log.error("Sorry, this function is available for macOS 10.11+ only")
            return nil
        }

        Log.verbose("Getting `Info.plist` for `\(appDir)`")
        let appUrl = URL.init(fileURLWithPath: appDir, isDirectory: true)
        let plistUrl = URL.init(fileURLWithPath: file, relativeTo: appUrl)

        let plistAbsPath = plistUrl.absoluteURL.path
        Log.verbose("Reading plist at \(plistAbsPath)")

        guard let plistDict = Plist.readToDict(from: plistAbsPath) else {
            Log.error("Unable to read plist at \(plistAbsPath)")
            return nil
        }

        guard let dicts = plistDict[key] as? [[String: Any]] else {
            Log.error("Unable to read `\(key)` from plist")
            return nil
        }

        let res = dicts.map { $0[subkey] as? [String] ?? [] }
            .reduce(Set<String>()) { $0.union($1) }

        Log.verbose("Got `\(subkey)`: \n\(res)")
        return res
    }

    static func readSupportedFileTypesFromBundle(
        _ appDir: String,
        file: String = "Contents/Info.plist"
    ) -> Set<String>? {
        return readInfoFromBundle(
            appDir,
            file: file,
            key: "CFBundleDocumentTypes",
            subkey: "LSItemContentTypes"
        )
    }

    static func readSupportedFileExtensionsFromBundle(
        _ appDir: String,
        file: String = "Contents/Info.plist"
    ) -> Set<String>? {
        return readInfoFromBundle(
            appDir,
            file: file,
            key: "CFBundleDocumentTypes",
            subkey: "CFBundleTypeExtensions"
        )
    }

    static func readSupportedUrlSchemesFromBundle(
        _ appDir: String,
        file: String = "Contents/Info.plist"
    ) -> Set<String>? {
        return readInfoFromBundle(
            appDir,
            file: file,
            key: "CFBundleURLTypes",
            subkey: "CFBundleURLSchemes"
        )
    }
}
