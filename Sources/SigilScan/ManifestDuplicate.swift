/// A value claimed by more than one declaration.
public struct ManifestDuplicate: Equatable, Sendable {
    /// The shared value.
    public let value: String

    /// The declarations using it, sorted by name.
    public let subjects: [String]
}
