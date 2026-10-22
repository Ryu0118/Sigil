/// A struct, class, enum or actor found in source, with its `@Labeled` labels.
public struct ScannedDeclaration: Codable, Equatable, Sendable {
    /// The name qualified by enclosing types, for example `Outer.Inner`.
    public let name: String

    /// `struct`, `class`, `enum` or `actor`.
    public let kind: String

    /// The file the declaration was found in, as passed to the scanner.
    public let path: String

    /// The 1-based line of the declaration.
    public let line: Int

    /// The inheritance clause entries as written, such as `View` or `Equatable`.
    public let inheritedTypes: [String]

    /// Attribute names other than `@Labeled`, such as `Reducer` or `MainActor`.
    public let attributes: [String]

    /// The labels from every `@Labeled` attribute, in source order.
    public let labels: [ScannedLabel]

    /// Creates a scanned declaration.
    public init(
        name: String,
        kind: String,
        path: String,
        line: Int,
        inheritedTypes: [String],
        attributes: [String],
        labels: [ScannedLabel]
    ) {
        self.name = name
        self.kind = kind
        self.path = path
        self.line = line
        self.inheritedTypes = inheritedTypes
        self.attributes = attributes
        self.labels = labels
    }
}
