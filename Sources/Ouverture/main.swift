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

main()
