import Foundation

func readPlistToDict(from plistPath: String) -> NSDictionary? {
    return NSDictionary(contentsOfFile: plistPath)
}
