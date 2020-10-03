import CoreFoundation
import CoreServices.LaunchServices
import Foundation
import LoggerAPI

public func getUtiString(
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

public func getDefaultHandler(forUti uti: CFString) -> CFString? {
    let res = LSCopyDefaultRoleHandlerForContentType(uti, .all)?
        .takeUnretainedValue()
    Log.verbose(
        "The default handler for UTI `\(uti)` is `\(res as String? ?? "Unknown")`"
    )
    return res
}

/// Get the default handler for a file type in the form of BundleID (eg. com.apple.TextEdit).
public func getDefaultHandler(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> CFString? {
    guard let uti = getUtiString(forExt: ext, conformingTo: parentUti) else {
        return nil
    }
    return getDefaultHandler(forUti: uti)
}

/// Get the default handler for a file type in the form of BundleID (eg. com.apple.TextEdit).
public func getDefaultHandler(forUrlScheme urlScheme: CFString) -> CFString? {
    let res = LSCopyDefaultHandlerForURLScheme(urlScheme)?.takeUnretainedValue()
    Log.verbose(
        "The default handler for URL Scheme `\(urlScheme)` is `\(res as String? ?? "Unknown")`"
    )
    return res
}

/// Get the possible handlers for a file type in the form of Bundle URL.
public func getHandlerCandidates(forUti uti: CFString) -> [NSURL]? {
    let res =
        LSCopyAllRoleHandlersForContentType(uti, .all)?.takeUnretainedValue()
        as? [NSURL]
    Log.verbose(
        "The handler candidates for UTI `\(uti)` are:\n`\(String(describing: res))`"
    )
    return res
}

/// Get the possible handlers for a file type in the form of Bundle URL.
public func getHandlerCandidates(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [NSURL]? {
    guard let uti = getUtiString(forExt: ext, conformingTo: parentUti) else {
        return nil
    }
    return getHandlerCandidates(forUti: uti)
}

/// Get the possible handlers for a URL scheme in the form of Bundle URL.
public func getHandlerCandidates(forUrlScheme urlScheme: CFString) -> [NSURL]? {
    let res =
        LSCopyAllHandlersForURLScheme(urlScheme)?.takeUnretainedValue()
        as? [NSURL]
    Log.verbose(
        "The handler candidates for URL Scheme `\(urlScheme)` are:\n`\(String(describing: res))`"
    )
    return res
}

public func setDefaultHandler(forUti uti: CFString, to bundleId: CFString)
    -> Bool
{
    Log.verbose("Setting default handler for UTI `\(uti) to `\(bundleId)`")
    let res =
        kOSReturnSuccess
        == LSSetDefaultRoleHandlerForContentType(uti, .all, bundleId)
    Log.verbose("Setting default handler " + (res ? "success" : "failed"))
    return res
}

public func setDefaultHandler(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil,
    to bundleId: CFString
) -> Bool {
    Log.verbose(
        "Setting default handler for extention `\(ext) to `\(bundleId)`"
    )
    guard let uti = getUtiString(forExt: ext, conformingTo: parentUti) else {
        return false
    }
    return setDefaultHandler(forUti: uti, to: bundleId)
}

public func setDefaultHandler(
    forUrlScheme urlScheme: CFString,
    to bundleId: CFString
) -> Bool {
    Log.verbose(
        "Setting default handler for URL Scheme `\(urlScheme) to `\(bundleId)`"
    )
    let res =
        kOSReturnSuccess == LSSetDefaultHandlerForURLScheme(urlScheme, bundleId)
    Log.verbose("Setting default handler " + (res ? "success" : "failed"))
    return res
}
