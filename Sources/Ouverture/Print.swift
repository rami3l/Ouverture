import Foundation

/// Print a long list in the form of columns.
public func printColumns(
    title: String? = nil,
    _ words: [String],
    columnCount: Int = 1,
    gapCount: Int = 2
) {
    if title != nil { print("-- \(title!) --") }
    guard let maxLen = words.map({ $0.count }).max() else { return }
    let blockLen = maxLen + gapCount
    let spaceCount = { (word: String) in blockLen - word.count }
    words.enumerated()
        .forEach {
            let i = $0 + 1
            let end =
                i % columnCount == 0
                ? "\n" : String(repeating: " ", count: spaceCount($1))
            // dump("\($1), \(end)")
            print($1, terminator: end)
        }

    if words.count % columnCount != 0 { print() }
    print()
}

/// Print a long list in the form of columns, the number of which is
/// automatically detected based on the terminal width.
/// Returns if this action has printed something.
public func printColumnsWithWidth(
    title: String? = nil,
    _ words: [String],
    width: Int? = getTerminalWidth(),
    gapCount: Int = 2
) -> Bool {
    guard let maxLen = words.map({ $0.count }).max() else { return false }
    let columnCount = width.map { $0 / maxLen } ?? 1
    printColumns(
        title: title,
        words,
        columnCount: columnCount,
        gapCount: gapCount
    )
    return true
}

public func getCommandOutput(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String =
        NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

    return output
}

public func getTerminalWidth() -> Int? {
    return Int(getCommandOutput("tput cols").trim())
}

public func getTerminalHeight() -> Int? {
    return Int(getCommandOutput("tput lines").trim())
}
