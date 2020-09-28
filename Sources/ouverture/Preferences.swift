import CoreServices.LaunchServices
import Foundation
import LoggerAPI

func getUtiString(forExt ext: String, conformingTo parentUti: CFString? = nil)
    -> CFString?
{
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

func getDefaultHandler(forUti uti: CFString) -> CFString? {
    let res = LSCopyDefaultRoleHandlerForContentType(uti, .all)?
        .takeUnretainedValue()
    Log.verbose(
        "The default handler for UTI `\(uti)` is `\(res as String? ?? "Unknown")`"
    )
    return res
}

func getDefaultHandler(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> CFString? {
    guard let uti = getUtiString(forExt: ext, conformingTo: parentUti) else {
        return nil
    }
    return getDefaultHandler(forUti: uti)
}

func getDefaultHandler(forUrlScheme urlScheme: CFString) -> CFString? {
    let res = LSCopyDefaultHandlerForURLScheme(urlScheme)?.takeUnretainedValue()
    Log.verbose(
        "The default handler for URL Scheme `\(urlScheme)` is `\(res as String? ?? "Unknown")`"
    )
    return res
}

func getHandlerCandidates(forUti uti: CFString) -> [CFString]? {
    let res =
        LSCopyAllRoleHandlersForContentType(uti, .all)?.takeUnretainedValue()
        as? [CFString]
    Log.verbose(
        "The handler candidates for UTI `\(uti)` are:\n`\(String(describing: res))`"
    )
    return res
}

func getHandlerCandidates(
    forExt ext: String,
    conformingTo parentUti: CFString? = nil
) -> [CFString]? {
    guard let uti = getUtiString(forExt: ext, conformingTo: parentUti) else {
        return nil
    }
    return getHandlerCandidates(forUti: uti)
}

func getHandlerCandidates(forUrlScheme urlScheme: CFString) -> [CFString]? {
    let res =
        LSCopyAllHandlersForURLScheme(urlScheme)?.takeUnretainedValue()
        as? [CFString]
    Log.verbose(
        "The handler candidates for URL Scheme `\(urlScheme)` are:\n`\(String(describing: res))`"
    )
    return res
}

func setDefaultHandler(forUti uti: CFString, to bundleId: CFString) -> Bool {
    Log.verbose("Setting default handler for UTI `\(uti) to `\(bundleId)`")
    let res =
        kOSReturnSuccess
        == LSSetDefaultRoleHandlerForContentType(uti, .all, bundleId)
    Log.verbose("Setting default handler " + (res ? "success" : "failed"))
    return res
}

func setDefaultHandler(
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

func setDefaultHandler(forUrlScheme urlScheme: CFString, to bundleId: CFString)
    -> Bool
{
    Log.verbose(
        "Setting default handler for URL Scheme `\(urlScheme) to `\(bundleId)`"
    )
    let res =
        kOSReturnSuccess == LSSetDefaultHandlerForURLScheme(urlScheme, bundleId)
    Log.verbose("Setting default handler " + (res ? "success" : "failed"))
    return res
}
