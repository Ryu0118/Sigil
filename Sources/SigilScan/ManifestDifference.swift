/// The result of comparing a manifest with an externally owned set of expected values.
public struct ManifestDifference: Equatable, Sendable {
    /// Expected values that no labeled declaration provides.
    public let missingFromCode: [String]

    /// Values found in code that the expected set does not contain.
    public let notExpected: [String]

    /// Whether code and the expected set agree exactly.
    public var isEmpty: Bool {
        missingFromCode.isEmpty && notExpected.isEmpty
    }
}
