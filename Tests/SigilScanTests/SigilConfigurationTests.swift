@testable import SigilScan
import Testing

@Suite("loads .sigil.yml and formats violations as compiler-style diagnostics")
struct SigilConfigurationTests {
    @Test("decodes requirements and treats omitted lists as empty")
    func decodesRequirements() throws {
        let configuration = try SigilConfiguration(
            yaml: """
            requirements:
              - label: ScreenLabel
                conformsTo: [View]
                include: ["Sources/**"]
              - label: OwnerLabel
                attributes: [Reducer]
            """
        )

        #expect(configuration.requirements.count == 2)
        #expect(configuration.requirements[0].conformsTo == ["View"])
        #expect(configuration.requirements[0].exclude.isEmpty)
        #expect(configuration.requirements[1].attributes == ["Reducer"])
    }

    @Test("an empty document means no requirements")
    func emptyDocument() throws {
        #expect(try SigilConfiguration(yaml: "{}").requirements.isEmpty)
    }

    @Test("a violation renders as file:line: error so Xcode and CI annotate it")
    func diagnosticFormat() {
        let violation = RequirementViolation(
            declaration: ScannedDeclaration(
                name: "HomeView", kind: "struct", path: "Sources/Home.swift", line: 12,
                inheritedTypes: ["View"], attributes: [], labels: []
            ),
            requirement: LabelRequirement(label: "ScreenLabel", conformsTo: ["View"])
        )

        #expect(violation.diagnostic == "Sources/Home.swift:12: error: HomeView must be annotated with @Labeled(ScreenLabel(...))")
    }
}
