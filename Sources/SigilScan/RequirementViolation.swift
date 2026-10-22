/// A declaration that a ``LabelRequirement`` selects but that lacks the required label.
public struct RequirementViolation: Equatable, Sendable {
    /// The unlabeled declaration.
    public let declaration: ScannedDeclaration

    /// The requirement it violates.
    public let requirement: LabelRequirement

    /// A `file:line: error:` line that Xcode and CI log parsers turn into an annotation.
    public var diagnostic: String {
        "\(declaration.path):\(declaration.line): error: \(declaration.name) must be annotated with @Labeled(\(requirement.label)(...))"
    }
}
