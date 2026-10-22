/// A declaration that a ``LabelRequirement`` selects but that lacks the required label.
public struct RequirementViolation: Equatable, Sendable {
    /// The unlabeled declaration.
    public let declaration: ScannedDeclaration

    /// The requirement it violates.
    public let requirement: LabelRequirement
}
