@testable import Sigil
import Testing

@Suite("reads @Labeled records back from the loaded images")
struct LabelRegistryTests {
    @Test("finds every annotated type in the running process")
    func findsAnnotatedTypes() {
        let subjects = LabelRegistry.entries().map { String(describing: $0.subject) }

        #expect(subjects.contains("HomeFixture"))
        #expect(subjects.contains("SettingsFixture"))
        #expect(subjects.contains("OwnerOnlyFixture"))
    }

    @Test("filters by label type and keeps each type's labels")
    func filtersByLabelType() {
        let screens = LabelRegistry.entries(carrying: ScreenLabel.self)
            .reduce(into: [String: [ScreenLabel]]()) { $0[String(describing: $1.subject)] = $1.labels }

        #expect(screens["HomeFixture"] == [ScreenLabel(name: "home")])
        #expect(screens["SettingsFixture"] == [ScreenLabel(name: "settings")])
        #expect(screens["OwnerOnlyFixture"] == nil)
    }

    @Test("keeps several labels of different kinds on one type in source order")
    func keepsAllLabelsInOrder() throws {
        let entry = try #require(
            LabelRegistry.entries().first { $0.subject == SettingsFixture.self }
        )

        #expect(entry.labels.count == 2)
        #expect(entry.labels(of: OwnerLabel.self) == [OwnerLabel(team: "growth")])
    }

    @Test("the generated conformance exposes labels without the registry")
    func staticLabelsMatchRecord() {
        let names = HomeFixture.labels.compactMap { ($0 as? ScreenLabel)?.name }

        #expect(names == ["home"])
    }
}
