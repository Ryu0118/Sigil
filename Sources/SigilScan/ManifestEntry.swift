/// One label argument value found in source.
public struct ManifestEntry: Codable, Equatable, Sendable {
    /// The argument value, for example a screen name.
    public let value: String

    /// The qualified name of the labeled declaration.
    public let subject: String

    /// The file the declaration is in.
    public let path: String

    /// The 1-based line of the declaration.
    public let line: Int
}
