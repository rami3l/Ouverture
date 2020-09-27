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

    static func getDefault(for ext: String) -> CFString {
        return LSCopyDefaultRoleHandlerForContentType(
            getUtiString(for: ext),
            .all
        )!.takeUnretainedValue()
    }

    static func setDefault(for ext: String, as cfBundleId: CFString) -> Bool {
        return kOSReturnSuccess
            == LSSetDefaultRoleHandlerForContentType(
                getUtiString(for: ext),
                .all,
                cfBundleId
            )
    }
}
