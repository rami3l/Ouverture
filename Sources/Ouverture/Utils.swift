import Foundation

extension String {
    /// Trim whitespace and newline characters from a `String`.
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Check if a String is a reverse domain name.
    public func isReverseDomain() -> Bool {
        return self.range(
            of: #"^[a-z]{2,}(\.[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*)+"#,
            options: .regularExpression
        ) != nil
    }
}
