import SwiftSyntax
import SwiftSyntaxMacros

/// The validated pieces of a `@Labeled` use that both expansions need.
struct LabeledSubjectDeclaration {
    let name: String
    let labelsLiteral: String

    init(declaration: some DeclGroupSyntax, node: AttributeSyntax) throws {
        guard
            declaration.is(StructDeclSyntax.self) || declaration.is(ClassDeclSyntax.self)
            || declaration.is(EnumDeclSyntax.self) || declaration.is(ActorDeclSyntax.self),
            let named = declaration.asProtocol(NamedDeclSyntax.self)
        else {
            throw LabeledMacroError.unsupportedDeclaration
        }
        if let generic = declaration.asProtocol(WithGenericParametersSyntax.self), generic.genericParameterClause != nil {
            throw LabeledMacroError.genericDeclaration
        }
        guard case let .argumentList(arguments) = node.arguments, !arguments.isEmpty else {
            throw LabeledMacroError.missingLabels
        }

        name = named.name.text
        labelsLiteral = "[" + arguments.map(\.expression.trimmedDescription).joined(separator: ", ") + "]"
    }
}
