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
    )?.takeUnretainedValue()
    if parentUti != nil {
        Log.verbose(
            "The UTI for extention `\(ext)` under `\(parentUti!)` is `\(res as String? ?? "Unknown")`"
        )
    }
    else {
        Log.verbose(
            "The preferred UTI for extention `\(ext)` is `\(res as String? ?? "Unknown")`"
        )
    }
    return res
}

public func getUtiDeclaration(forUti uti: CFString) -> [String: AnyObject]? {
    return UTTypeCopyDeclaration(uti)?.takeUnretainedValue()
        as? [String: AnyObject]
}

public func getUtiDeclaration(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [String: AnyObject]? {
    return getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        getUtiDeclaration(forUti: $0)
    }
}

public func getUtiDescription(forUti uti: CFString) -> CFString? {
    return getUtiDeclaration(forUti: uti)?["UTTypeDescription"] as! CFString?
}

public func getUtiDescription(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> CFString? {
    return getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        getUtiDescription(forUti: $0)
    }
}

public func getUtiParents(forUti uti: CFString) -> [CFString]? {
    return getUtiDeclaration(forUti: uti)?["UTTypeConformsTo"] as! [CFString]?
}

public func getUtiParents(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [CFString]? {
    return getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        getUtiParents(forUti: $0)
    }
}

public func getUtiExtensions(forUti uti: CFString) -> [CFString]? {
    let tagSpec =
        getUtiDeclaration(forUti: uti)?["UTTypeTagSpecification"]
        as? [String: AnyObject]
    return tagSpec?["public.filename-extension"] as! [CFString]?
}

public func getUtiExtensions(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [CFString]? {
    return getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        getUtiExtensions(forUti: $0)
    }
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
    return getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        return getDefaultHandler(forUti: $0)
    }
}

/// Get the default handler for a file type in the form of BundleID (eg. com.apple.TextEdit).
public func getDefaultHandler(forUrlScheme urlScheme: CFString) -> CFString? {
    let res = LSCopyDefaultHandlerForURLScheme(urlScheme)?.takeUnretainedValue()
    Log.verbose(
        "The default handler for URL Scheme `\(urlScheme)` is `\(res as String? ?? "Unknown")`"
    )
    return res
}

/// Get the possible handlers for a file type in the form of Bundle ID.
public func getHandlerCandidates(forUti uti: CFString) -> [CFString]? {
    let res =
        LSCopyAllRoleHandlersForContentType(uti, .all)?.takeUnretainedValue()
        as? [CFString]
    Log.verbose(
        "The handler candidates for UTI `\(uti)` are:\n`\(String(describing: res))`"
    )
    return res
}

/// Get the possible handlers for a file type in the form of Bundle ID.
public func getHandlerCandidates(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [CFString]? {
    getUtiString(forExt: ext, conformingTo: parentUti).flatMap {
        return getHandlerCandidates(forUti: $0)
    }
}

/// Get the possible handlers for a URL scheme in the form of Bundle ID.
public func getHandlerCandidates(
    forUrlScheme urlScheme: CFString
) -> [CFString]? {
    let res =
        LSCopyAllHandlersForURLScheme(urlScheme)?.takeUnretainedValue()
        as? [CFString]
    Log.verbose(
        "The handler candidates for URL Scheme `\(urlScheme)` are:\n`\(String(describing: res))`"
    )
    return res
}

public func setDefaultHandler(
    forUti uti: CFString,
    to bundleId: CFString
) -> Bool {
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
    Log.verbose("Setting default handler \(res ? "success" : "failed").")
    return res
}
