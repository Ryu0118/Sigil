@testable import SigilScan
import Testing

@Suite("scans Swift source for nominal declarations and their @Labeled attributes")
struct DeclarationScannerTests {
    private func scan(_ source: String) -> [ScannedDeclaration] {
        DeclarationScanner.scan(source: source, path: "Sample.swift")
    }

    @Test("reads the label type and its string arguments")
    func readsLabelArguments() throws {
        let declarations = scan(
            """
            @Labeled(ScreenLabel(name: "home", analyticsClass: "HomeView"))
            struct HomeView: View {}
            """
        )

        let home = try #require(declarations.first)
        #expect(home.name == "HomeView")
        #expect(home.labels == [ScannedLabel(type: "ScreenLabel", arguments: ["name": "home", "analyticsClass": "HomeView"])])
    }

    @Test("keeps several labels in source order")
    func keepsSeveralLabels() throws {
        let declarations = scan(
            """
            @Labeled(ScreenLabel(name: "settings"), OwnerLabel(team: "growth"))
            enum Settings {}
            """
        )

        let settings = try #require(declarations.first)
        #expect(settings.labels.map(\.type) == ["ScreenLabel", "OwnerLabel"])
    }

    @Test("qualifies nested declarations and records conformances without labels")
    func qualifiesNestedNames() {
        let declarations = scan(
            """
            struct Outer {
                struct Inner: View, Equatable {}
            }
            """
        )

        let inner = declarations.first { $0.name == "Outer.Inner" }
        #expect(inner?.inheritedTypes == ["View", "Equatable"])
        #expect(inner?.labels.isEmpty == true)
    }

    @Test("reports 1-based source lines")
    func reportsLines() {
        let declarations = scan("\n\nstruct Late {}\n")

        #expect(declarations.first?.line == 3)
    }

    @Test("ignores @Labeled on extensions, which cannot hold records")
    func ignoresExtensions() {
        let declarations = scan("@Labeled(Tag())\nextension Foo {}")

        #expect(declarations.isEmpty)
    }

    @Test("accepts the module-qualified attribute spelling")
    func acceptsQualifiedAttribute() {
        let declarations = scan("@Sigil.Labeled(Tag())\nstruct Q {}")

        #expect(declarations.first?.labels.map(\.type) == ["Tag"])
    }

    @Test("records non-literal arguments as their source text")
    func recordsExpressionArguments() {
        let declarations = scan("@Labeled(ScreenLabel(name: Names.home))\nstruct E {}")

        #expect(declarations.first?.labels.first?.arguments["name"] == "Names.home")
    }
}
