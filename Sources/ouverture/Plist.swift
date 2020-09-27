import Foundation

enum Plist {}

extension Plist {
    static func readToDict(from plistPath: String) -> NSDictionary? {
        return NSDictionary(contentsOfFile: plistPath)
    }
}
