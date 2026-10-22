/// The values one label argument takes across a scanned code base.
public struct Manifest: Codable, Equatable, Sendable {
    /// Entries sorted by value, then subject.
    public let entries: [ManifestEntry]

    /// Builds the manifest of `argument` on every label of type `label`.
    public init(declarations: [ScannedDeclaration], label: String, argument: String) {
        entries = declarations
            .flatMap { declaration in
                declaration.labels
                    .filter { $0.type == label }
                    .compactMap { $0.arguments[argument] }
                    .map { ManifestEntry(value: $0, subject: declaration.name, path: declaration.path, line: declaration.line) }
            }
            .sorted { ($0.value, $0.subject) < ($1.value, $1.subject) }
    }

    /// Values claimed by two or more distinct declarations.
    public var duplicates: [ManifestDuplicate] {
        Dictionary(grouping: entries, by: \.value)
            .compactMap { value, group in
                let subjects = Set(group.map(\.subject))
                return subjects.count > 1 ? ManifestDuplicate(value: value, subjects: subjects.sorted()) : nil
            }
            .sorted { $0.value < $1.value }
    }

    /// Compares the manifest's values with `expected`.
    public func compare(toExpected expected: Set<String>) -> ManifestDifference {
        let actual = Set(entries.map(\.value))
        return ManifestDifference(
            missingFromCode: expected.subtracting(actual).sorted(),
            notExpected: actual.subtracting(expected).sorted()
        )
    }
}
