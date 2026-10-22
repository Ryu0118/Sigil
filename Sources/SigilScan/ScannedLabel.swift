/// One label expression found inside an `@Labeled(...)` attribute.
public struct ScannedLabel: Codable, Equatable, Sendable {
    /// The label type as written, for example `ScreenLabel`.
    public let type: String

    /// The call arguments keyed by argument label (`_0`, `_1` for unlabeled ones).
    ///
    /// String literals are stored without quotes; any other expression is stored as source text.
    public let arguments: [String: String]

    /// Creates a scanned label.
    public init(type: String, arguments: [String: String]) {
        self.type = type
        self.arguments = arguments
    }
}
