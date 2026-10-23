import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implements `@Labeled(...)`: a section record plus a `LabeledSubject` conformance.
public struct LabeledMacro {}

extension LabeledMacro: MemberMacro {
    /// Emits the `__DATA,__sigil` section record for the labeled type.
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let subject = try LabeledSubjectDeclaration(declaration: declaration, node: node)

        return [
            """
            #if objectFormat(MachO)
            @section("__DATA,__sigil")
            @used
            nonisolated static let __sigilRecord: Sigil.LabelRecord = (
                1,
                { out in
                    out.bindMemory(to: Sigil.LabelEntry.self, capacity: 1).initialize(
                        to: Sigil.LabelEntry(subject: \(raw: subject.name).self, labels: \(raw: subject.labelsLiteral))
                    )
                }
            )
            #endif
            """,
        ]
    }
}

extension LabeledMacro: ExtensionMacro {
    /// Emits the `LabeledSubject` conformance that exposes the labels statically.
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let subject = try LabeledSubjectDeclaration(declaration: declaration, node: node)

        let conformance: DeclSyntax = """
        extension \(type.trimmed): Sigil.LabeledSubject {
            \(raw: subject.accessModifier.isEmpty ? "" : subject.accessModifier + " ")nonisolated static var labels: [any Sigil.Label] {
                \(raw: subject.labelsLiteral)
            }
        }
        """
        return [conformance.cast(ExtensionDeclSyntax.self)]
    }
}
