@testable import SigilMacros
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosGenericTestSupport
import Testing

@Suite("expands @Labeled into a section record and a conformance")
struct LabeledMacroExpansionTests {
    private let macros: [String: any Macro.Type] = ["Labeled": LabeledMacro.self]

    @Test("a struct gets a section record and a LabeledSubject conformance")
    func structExpansion() {
        assertMacroExpansion(
            """
            @Labeled(ScreenLabel(name: "home"))
            struct HomeScreen {}
            """,
            expandedSource: """
            struct HomeScreen {

                #if objectFormat(MachO)
                @section("__DATA,__sigil")
                @used
                nonisolated static let __sigilRecord: Sigil.LabelRecord = (
                    1,
                    { out in
                        out.bindMemory(to: Sigil.LabelEntry.self, capacity: 1).initialize(
                            to: Sigil.LabelEntry(subject: HomeScreen.self, labels: [ScreenLabel(name: "home")])
                        )
                    }
                )
                #endif
            }

            extension HomeScreen: Sigil.LabeledSubject {
                nonisolated static var labels: [any Sigil.Label] {
                    [ScreenLabel(name: "home")]
                }
            }
            """,
            macroSpecs: macros.mapValues { MacroSpec(type: $0) },
            failureHandler: { Issue.record(Comment(rawValue: $0.message)) }
        )
    }

    @Test("the conformance member takes the access level of a public type")
    func publicTypeExposesLabelsPublicly() {
        assertMacroExpansion(
            """
            @Labeled(Tag())
            public struct Open {}
            """,
            expandedSource: """
            public struct Open {

                #if objectFormat(MachO)
                @section("__DATA,__sigil")
                @used
                nonisolated static let __sigilRecord: Sigil.LabelRecord = (
                    1,
                    { out in
                        out.bindMemory(to: Sigil.LabelEntry.self, capacity: 1).initialize(
                            to: Sigil.LabelEntry(subject: Open.self, labels: [Tag()])
                        )
                    }
                )
                #endif
            }

            extension Open: Sigil.LabeledSubject {
                public nonisolated static var labels: [any Sigil.Label] {
                    [Tag()]
                }
            }
            """,
            macroSpecs: macros.mapValues { MacroSpec(type: $0) },
            failureHandler: { Issue.record(Comment(rawValue: $0.message)) }
        )
    }

    @Test("a package type exposes labels at package level")
    func packageTypeExposesLabelsAtPackageLevel() {
        assertMacroExpansion(
            """
            @Labeled(Tag())
            package enum Inner {}
            """,
            expandedSource: """
            package enum Inner {

                #if objectFormat(MachO)
                @section("__DATA,__sigil")
                @used
                nonisolated static let __sigilRecord: Sigil.LabelRecord = (
                    1,
                    { out in
                        out.bindMemory(to: Sigil.LabelEntry.self, capacity: 1).initialize(
                            to: Sigil.LabelEntry(subject: Inner.self, labels: [Tag()])
                        )
                    }
                )
                #endif
            }

            extension Inner: Sigil.LabeledSubject {
                package nonisolated static var labels: [any Sigil.Label] {
                    [Tag()]
                }
            }
            """,
            macroSpecs: macros.mapValues { MacroSpec(type: $0) },
            failureHandler: { Issue.record(Comment(rawValue: $0.message)) }
        )
    }
}
