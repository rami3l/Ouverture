import HeliumLogger
import LoggerAPI

func main() {
    // Enable logger.
    let logger = HeliumLogger(.verbose)
    logger.colored = true
    Log.logger = logger

    print("Hello, ouverture!")
    test1()
    test2()
}

func test1() {
    let ext = "rs"
    Preferences.getUtiString(forExt: ext)
    Preferences.getDefault(forExt: ext)
    Preferences.getCandidates(forExt: ext)
}

func test2() {
    let apps = ["Mock/IINA.app", "Mock/Music.app", "Mock/Safari.app"]
    for app in apps {
        Preferences.readSupportedFileTypesFromBundle(app)
        Preferences.readSupportedFileExtensionsFromBundle(app)
        Preferences.readSupportedUrlSchemesFromBundle(app)
    }
}

main()
