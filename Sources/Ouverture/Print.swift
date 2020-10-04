import Foundation

/// Print a long list in the form of columns.
public func printColumns(
    title: String? = nil,
    _ words: [String],
    columnCount: Int = 1,
    gapCount: Int = 2
) {
    if title != nil { print("-- \(title!) --") }
    if words.isEmpty { print("(Nothing to print)") }
    let lineCount: Int = {
        let (q, r) = words.count.quotientAndRemainder(dividingBy: columnCount)
        return r == 0 ? q : q + 1
    }()
    let matrix: [[String]] = {
        var res = [[String]](
            repeating: [String](repeating: "", count: columnCount),
            count: lineCount
        )
        for (n, word) in words.enumerated() {
            let (ln, col) = n.quotientAndRemainder(dividingBy: columnCount)
            res[ln][col] = word
        }
        return res
    }()
    let maxLen = (0..<columnCount)
        .map { col in matrix.map { $0[col].count }.max()! }
    let blockLen = maxLen.map { $0 + gapCount }
    matrix.enumerated()
        .forEach { (ln, ws) in
            ws.enumerated()
                .forEach { (col, w) in
                    let end = col == columnCount - 1 ? "\n" : ""
                    print(
                        matrix[ln][col]
                            .padding(
                                toLength: blockLen[col],
                                withPad: " ",
                                startingAt: 0
                            ),
                        terminator: end
                    )
                }
        }

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
