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
    if #unavailable(macOS 10.15) {
        Log.warning("The result is optimal for macOS 10.15+ only")
    }

    let candidates = getBundleUrlCandidates(from: bundleId)
    let res = candidates?[0]
    Log.verbose(
        "The best URL for bundle `\(bundleId)` is: `\(res?.absoluteURL?.path ?? "Unknown")`"
    )
    return res
}

public func getBundleId(
    from appPath: String,
    file: String = "Contents/Info.plist"
) -> String? {
    guard #available(macOS 10.11, *) else {
        Log.error("`\(#function)` is available in macOS 10.11+ only")
        return nil
    }

    Log.verbose("Getting `Info.plist` for `\(appPath)`")
    let appUrl = URL.init(fileURLWithPath: appPath, isDirectory: true)
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
    _ appPath: String,
    file: String = "Contents/Info.plist",
    key: String,
    subkey: String
) -> [String]? {
    guard #available(macOS 10.11, *) else {
        Log.error("\(#function) is available in macOS 10.11+ only")
        return nil
    }

    Log.verbose("Getting `Info.plist` for `\(appPath)`")
    let appUrl = URL.init(fileURLWithPath: appPath, isDirectory: true)
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
        .reduce(Set()) { $0.union($1) }
        .sorted()

    Log.verbose("Got `\(subkey)`: \n\(res)")
    return res
}

public func readSupportedFileTypesFromBundle(
    _ appPath: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appPath,
        file: file,
        key: "CFBundleDocumentTypes",
        subkey: "LSItemContentTypes"
    )
}

public func readSupportedFileExtensionsFromBundle(
    _ appPath: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appPath,
        file: file,
        key: "CFBundleDocumentTypes",
        subkey: "CFBundleTypeExtensions"
    )
}

public func readSupportedUrlSchemesFromBundle(
    _ appPath: String,
    file: String = "Contents/Info.plist"
) -> [String]? {
    return readInfoFromBundle(
        appPath,
        file: file,
        key: "CFBundleURLTypes",
        subkey: "CFBundleURLSchemes"
    )
}
