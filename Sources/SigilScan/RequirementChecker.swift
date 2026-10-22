/// Finds declarations that violate label requirements.
public enum RequirementChecker {
    /// Returns every declaration a requirement selects that carries no label of the required type.
    public static func violations(
        in declarations: [ScannedDeclaration],
        against requirements: [LabelRequirement]
    ) -> [RequirementViolation] {
        requirements.flatMap { requirement in
            declarations
                .filter { selects(requirement, $0) && !$0.labels.contains { $0.type == requirement.label } }
                .map { RequirementViolation(declaration: $0, requirement: requirement) }
        }
    }

    private static func selects(_ requirement: LabelRequirement, _ declaration: ScannedDeclaration) -> Bool {
        let inScope = (requirement.include.isEmpty || GlobMatcher.matches(declaration.path, anyOf: requirement.include))
            && !GlobMatcher.matches(declaration.path, anyOf: requirement.exclude)
        let matchesType = !Set(requirement.conformsTo).isDisjoint(with: declaration.inheritedTypes)
            || !Set(requirement.attributes).isDisjoint(with: declaration.attributes)

        return inScope && matchesType
    }
}
