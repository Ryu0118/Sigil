@testable import SigilMacros
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacrosGenericTestSupport
import Testing

@Suite("rejects @Labeled on declarations it cannot register")
struct LabeledMacroDiagnosticsTests {
    private func diagnostics(for source: String) -> [String] {
        var messages: [String] = []
        assertMacroExpansion(
            source,
            expandedSource: "",
            macroSpecs: ["Labeled": MacroSpec(type: LabeledMacro.self)],
            failureHandler: { messages.append($0.message) }
        )
        return messages
    }

    @Test(
        "rejects declarations that cannot hold a section record",
        arguments: [
            ("@Labeled(Tag())\nstruct Box<T> {}", "generic type"),
            ("@Labeled(Tag())\nprotocol Marker {}", "structs, classes, enums and actors"),
            ("@Labeled()\nstruct Plain {}", "at least one label"),
        ]
    )
    func rejectsInvalidUse(source: String, expectedFragment: String) {
        let messages = diagnostics(for: source)

        #expect(messages.contains { $0.contains(expectedFragment) }, "got: \(messages)")
    }
}
