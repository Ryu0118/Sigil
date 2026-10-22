/// A type annotated with ``Labeled(_:)``.
///
/// The macro adds this conformance, so the labels are also reachable
/// without the registry, for example `HomeScreen.labels`.
public protocol LabeledSubject {
    /// The labels attached with ``Labeled(_:)``.
    static var labels: [any Label] { get }
}
