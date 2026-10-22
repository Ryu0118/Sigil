import Foundation

/// Matches relative file paths against `*` / `**` glob patterns.
enum GlobMatcher {
    static func matches(_ path: String, anyOf patterns: [String]) -> Bool {
        patterns.contains { matches(path, pattern: $0) }
    }

    private static func matches(_ path: String, pattern: String) -> Bool {
        guard let regex = try? Regex(regularExpression(for: pattern)) else { return false }

        return path.wholeMatch(of: regex) != nil
    }

    private static func regularExpression(for pattern: String) -> String {
        var result = ""
        var rest = Substring(pattern)
        while !rest.isEmpty {
            let (fragment, consumed) = translate(rest)
            result += fragment
            rest = rest.dropFirst(consumed)
        }
        return result
    }

    /// Returns the regular-expression fragment for the glob token at the start of `rest`
    /// and how many characters of `rest` it consumed.
    private static func translate(_ rest: Substring) -> (fragment: String, consumed: Int) {
        if rest.hasPrefix("**/") {
            return ("(.*/)?", 3)
        }
        if rest.hasPrefix("**") {
            return (".*", 2)
        }
        if rest.hasPrefix("*") {
            return ("[^/]*", 1)
        }

        return (NSRegularExpression.escapedPattern(for: String(rest.prefix(1))), 1)
    }
}
