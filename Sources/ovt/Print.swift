func printColumns(title: String? = nil, _ lines: [String], count: Int = 3) {
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
