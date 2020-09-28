import CoreFoundation
import HeliumLogger
import LoggerAPI

func main() {
    // Enable logger.
    let logger = HeliumLogger(.verbose)
    logger.colored = true
    Log.logger = logger

    print("Hello, Ouverture!")
    test1()
    test2()
    test3()
}

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

func test3() {
    let app = "com.apple.TextEdit"
    getBundleUrlCandidates(from: app as CFString)
}

main()
