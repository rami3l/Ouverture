import Foundation

func printColumns(title: String? = nil, _ lines: [String], count: Int = 1) {
    if title != nil { print("-- \(title!) --") }
    // Count of full lines.
    let q = lines.count / count
    // All terminators on one line.
    let lt = Array(repeating: "\t", count: count - 1) + ["\n"]
    var ltAll: [String] = Array(repeating: lt, count: q + 1).flatMap { $0 }
    ltAll[lines.count - 1] = "\n"
    let pairs = zip(lines, ltAll)
    pairs.forEach { print($0, terminator: $1) }
    print()
}

func printColumnsWithWidth(
    title: String? = nil,
    _ lines: [String],
    width: Int? = getTerminalWidth()
) {
    guard let maxLineWidth = lines.map({ $0.count }).max() else { return }
    if maxLineWidth == 0 { return }

    let tabWidth = makeMul(maxLineWidth, 8)
    let count = width.map { $0 / tabWidth } ?? 1
    printColumns(title: title, lines, count: count)
}

func getCommandOutput(_ command: String) -> String {
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

extension String {
    /// Trim whitespace and newline characters from a `String`.
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

func getTerminalWidth() -> Int? {
    return Int(getCommandOutput("tput cols").trim())
}

func getTerminalHeight() -> Int? {
    return Int(getCommandOutput("tput lines").trim())
}

/// Return the smallest multiple c of b such that c >= a.
func makeMul(_ a: Int, _ b: Int) -> Int {
    let (q, r) = a.quotientAndRemainder(dividingBy: b)
    if r == 0 {
        return a
    }
    else {
        return (q + 1) * b
    }
}
