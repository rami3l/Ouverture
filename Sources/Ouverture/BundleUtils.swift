import CoreServices.LaunchServices
import Foundation
import LoggerAPI

public func getBundleUrlCandidates(from bundleId: CFString) -> [NSURL]? {
    let res =
        LSCopyApplicationURLsForBundleIdentifier(bundleId, nil)?
        .takeUnretainedValue() as? [NSURL]
    Log.verbose(
        "The URL candidates for bundle `\(bundleId)` are:\n`\(String(describing: res))`"
    )
    return res
}

public func getBundleUrl(from bundleId: CFString) -> NSURL? {
    if #available(macOS 10.15, *) {
    } else {
        Log.error("The result is optimal for macOS 10.15+ only")
    }

    let candidates = getBundleUrlCandidates(from: bundleId)
    let res = candidates?[0]
    Log.verbose(
        "The best URL for bundle `\(bundleId)` is: `\(res?.absoluteString ?? "Unknown")`"
    )
    return res
}

public func getBundleId(
    from appDir: String,
    file: String = "Contents/Info.plist"
) -> String? {
    guard #available(macOS 10.11, *) else {
        Log.error("Function available in macOS 10.11+ only")
        return nil
    }

    Log.verbose("Getting `Info.plist` for `\(appDir)`")
    let appUrl = URL.init(fileURLWithPath: appDir, isDirectory: true)
    let plistUrl = URL.init(fileURLWithPath: file, relativeTo: appUrl)

    let plistAbsPath = plistUrl.absoluteURL.path
    Log.verbose("Reading plist at \(plistAbsPath)")

    guard let plistDict = readPlistToDict(from: plistAbsPath) else {
        Log.error("Unable to read plist at \(plistAbsPath)")
        return nil
    }

    return plistDict["CFBundleIdentifier"] as? String
}

private func readInfoFromBundle(
    _ appDir: String,
    file: String = "Contents/Info.plist",
    key: String,
    subkey: String
) -> [String]? {
    guard #available(macOS 10.11, *) else {
        Log.error("Function available in macOS 10.11+ only")
        return nil
    }

    Log.verbose("Getting `Info.plist` for `\(appDir)`")
    let appUrl = URL.init(fileURLWithPath: appDir, isDirectory: true)
    let plistUrl = URL.init(fileURLWithPath: file, relativeTo: appUrl)

    let plistAbsPath = plistUrl.absoluteURL.path
    Log.verbose("Reading plist at \(plistAbsPath)")

    guard let plistDict = readPlistToDict(from: plistAbsPath) else {
        Log.error("Unable to read plist at \(plistAbsPath)")
        return nil
    }

    guard let dicts = plistDict[key] as? [[String: Any]] else {
        Log.error("Unable to read `\(key)` from plist")
        return nil
    }

    let res = dicts.map { $0[subkey] as? [String] ?? [] }
        .reduce(Set<String>()) { $0.union($1) }.sorted()

    Log.verbose("Got `\(subkey)`: \n\(res)")
    return res
}

public func readSupportedFileTypesFromBundle(
    _ appDir: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appDir,
        file: file,
        key: "CFBundleDocumentTypes",
        subkey: "LSItemContentTypes"
    )
}

public func readSupportedFileExtensionsFromBundle(
    _ appDir: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appDir,
        file: file,
        key: "CFBundleDocumentTypes",
        subkey: "CFBundleTypeExtensions"
    )
}

public func readSupportedUrlSchemesFromBundle(
    _ appDir: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appDir,
        file: file,
        key: "CFBundleURLTypes",
        subkey: "CFBundleURLSchemes"
    )
}

// Check if a String is a reverse domain name BundleID.
public func isBundleId(_ s: String) -> Bool {
    return s.range(
        of: #"^[a-z]{2,}(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)+"#,
        options: .regularExpression
    ) != nil
}
