import HeliumLogger
import LoggerAPI

// Enable the logger.
func loggerInit(_ verbosity: LoggerMessageType) {
    let logger = HeliumLogger(verbosity)
    logger.colored = true
    Log.logger = logger
}
