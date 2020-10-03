import CoreFoundation
import Foundation
import HeliumLogger
import LoggerAPI
import OuvertureLib

func main() {
    // Enable logger.
    let logger = HeliumLogger(.verbose)
    logger.colored = true
    Log.logger = logger

    print("Hello, Ouverture!")
}

/*
func test1() {
    let ext = "rs"
    getUtiString(forExt: ext)
    getDefaultHandler(forExt: ext)
    getHandlerCandidates(forExt: ext)
}

func test2() {
    let apps = ["Mock/IINA.app"]
    for app in apps {
        readSupportedFileTypesFromBundle(app)
        readSupportedFileExtensionsFromBundle(app)
        readSupportedUrlSchemesFromBundle(app)
    }
}
*/

main()
