/// A declaration together with the labels attached to it by ``Labeled(_:)``.
public struct LabelEntry: Sendable {
    /// The declaration the labels were attached to.
    public let subject: Any.Type

    /// Every label passed to one `@Labeled` attribute, in source order.
    public let labels: [any Label]

    /// Creates an entry. Macro expansions call this; call sites rarely need to.
    public init(subject: Any.Type, labels: [any Label]) {
        self.subject = subject
        self.labels = labels
    }

    /// Returns the labels of one concrete type.
    public func labels<L: Label>(of _: L.Type = L.self) -> [L] {
        labels.compactMap { $0 as? L }
    }
}
