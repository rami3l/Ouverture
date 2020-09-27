import CoreServices.LaunchServices
import Foundation
import LoggerAPI

enum BundleUtils {}

extension BundleUtils {
    static func getBundleUrlCandidates(from bundleId: CFString) -> [CFString]? {
        let res =
            LSCopyApplicationURLsForBundleIdentifier(bundleId, nil)?
            .takeUnretainedValue() as? [CFString]
        Log.verbose(
            "The URL candidates for bundle `\(bundleId)` are:\n`\(String(describing: res))`"
        )
        return res
    }

    static func getBestBundleUrl(from bundleId: CFString) -> CFString? {
        guard #available(macOS 10.15, *) else {
            Log.error("Function available in macOS 10.15+ only")
            return nil
        }

        let candidates = getBundleUrlCandidates(from: bundleId)
        let res = candidates?[0]
        Log.verbose(
            "The best URL for bundle `\(bundleId)` is: `\(res as String? ?? "Unknown")`"
        )
        return res
    }

    static func readInfoFromBundle(
        _ appDir: String,
        file: String = "Contents/Info.plist",
        key: String,
        subkey: String
    ) -> Set<String>? {
        guard #available(macOS 10.11, *) else {
            Log.error("Function available in macOS 10.11+ only")
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
