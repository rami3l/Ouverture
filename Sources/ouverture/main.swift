import HeliumLogger
import LoggerAPI

func main() {
    // Enable logger.
    let logger = HeliumLogger(.verbose)
    logger.colored = true
    Log.logger = logger

    print("Hello, ouverture!")
    test2()
}

func test1() {
    let ext = "txt"
    Preferences.getUtiString(for: ext)
    Preferences.getDefault(for: ext)
}

func test2() {
    let dir = "Mock"
    Preferences.readSupportedFileTypesFromPlist(fromApp: dir)
}

main()
