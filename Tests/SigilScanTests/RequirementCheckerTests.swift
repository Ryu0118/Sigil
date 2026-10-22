@testable import SigilScan
import Testing

@Suite("flags declarations that match a requirement but carry no label of the required type")
struct RequirementCheckerTests {
    private func declaration(
        _ name: String,
        path: String = "Sources/App/Home.swift",
        inherits: [String] = [],
        attributes: [String] = [],
        labels: [ScannedLabel] = []
    ) -> ScannedDeclaration {
        ScannedDeclaration(
            name: name, kind: "struct", path: path, line: 1,
            inheritedTypes: inherits, attributes: attributes, labels: labels
        )
    }

    private let screens = LabelRequirement(label: "ScreenLabel", conformsTo: ["View"], include: ["Sources/**"], exclude: ["**/Components/**"])

    @Test("an unlabeled View in an included path is a violation")
    func unlabeledViewIsViolation() {
        let violations = RequirementChecker.violations(in: [declaration("HomeView", inherits: ["View"])], against: [screens])

        #expect(violations.map(\.declaration.name) == ["HomeView"])
    }

    @Test("a View carrying the required label type passes")
    func labeledViewPasses() {
        let label = ScannedLabel(type: "ScreenLabel", arguments: ["name": "home"])

        #expect(RequirementChecker.violations(in: [declaration("HomeView", inherits: ["View"], labels: [label])], against: [screens]).isEmpty)
    }

    @Test("a label of a different type does not satisfy the requirement")
    func otherLabelTypeDoesNotCount() {
        let label = ScannedLabel(type: "OwnerLabel", arguments: [:])

        #expect(RequirementChecker.violations(in: [declaration("HomeView", inherits: ["View"], labels: [label])], against: [screens]).count == 1)
    }

    @Test("excluded paths and non-matching types are ignored")
    func ignoresExcludedAndUnrelated() {
        let declarations = [
            declaration("Chip", path: "Sources/App/Components/Chip.swift", inherits: ["View"]),
            declaration("Model", inherits: ["Equatable"]),
            declaration("Fixture", path: "Tests/Fixture.swift", inherits: ["View"]),
        ]

        #expect(RequirementChecker.violations(in: declarations, against: [screens]).isEmpty)
    }

    @Test("a requirement can select by attribute instead of conformance")
    func selectsByAttribute() {
        let reducers = LabelRequirement(label: "ScreenLabel", attributes: ["Reducer"], include: ["**"])

        #expect(RequirementChecker.violations(in: [declaration("HomeReducer", attributes: ["Reducer"])], against: [reducers]).count == 1)
    }
}
