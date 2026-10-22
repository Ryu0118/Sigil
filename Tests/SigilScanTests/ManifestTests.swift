@testable import SigilScan
import Testing

@Suite("lists label argument values and detects duplicates")
struct ManifestTests {
    private func declaration(_ name: String, line: Int = 1, labels: [ScannedLabel]) -> ScannedDeclaration {
        ScannedDeclaration(
            name: name, kind: "struct", path: "\(name).swift", line: line,
            inheritedTypes: [], attributes: [], labels: labels
        )
    }

    private func screen(_ value: String) -> ScannedLabel {
        ScannedLabel(type: "ScreenLabel", arguments: ["name": value])
    }

    @Test("collects one entry per label of the requested type, sorted by value")
    func collectsSortedValues() {
        let declarations = [
            declaration("B", labels: [screen("settings")]),
            declaration("A", labels: [screen("home"), ScannedLabel(type: "OwnerLabel", arguments: ["team": "x"])]),
        ]

        let manifest = Manifest(declarations: declarations, label: "ScreenLabel", argument: "name")

        #expect(manifest.entries.map(\.value) == ["home", "settings"])
        #expect(manifest.entries.map(\.subject) == ["A", "B"])
    }

    @Test("skips labels that lack the requested argument")
    func skipsMissingArgument() {
        let declarations = [declaration("A", labels: [ScannedLabel(type: "ScreenLabel", arguments: [:])])]

        #expect(Manifest(declarations: declarations, label: "ScreenLabel", argument: "name").entries.isEmpty)
    }

    @Test("reports a value used by two different declarations")
    func reportsDuplicates() {
        let declarations = [
            declaration("A", labels: [screen("home")]),
            declaration("B", labels: [screen("home")]),
            declaration("C", labels: [screen("other")]),
        ]

        let duplicates = Manifest(declarations: declarations, label: "ScreenLabel", argument: "name").duplicates

        #expect(duplicates.map(\.value) == ["home"])
        #expect(duplicates.first?.subjects == ["A", "B"])
    }

    @Test("lists values missing from, and unexpected beside, an expected set")
    func comparesAgainstExpected() {
        let declarations = [declaration("A", labels: [screen("home")]), declaration("B", labels: [screen("extra")])]
        let manifest = Manifest(declarations: declarations, label: "ScreenLabel", argument: "name")

        let difference = manifest.compare(toExpected: ["home", "missing"])

        #expect(difference.missingFromCode == ["missing"])
        #expect(difference.notExpected == ["extra"])
    }
}
