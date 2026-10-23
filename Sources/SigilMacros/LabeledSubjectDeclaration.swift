import SwiftSyntax
import SwiftSyntaxMacros

/// The validated pieces of a `@Labeled` use that both expansions need.
struct LabeledSubjectDeclaration {
    let name: String
    let labelsLiteral: String

    /// `public`, `package` or empty. The generated `labels` must be at least as visible as the type
    /// because it satisfies a requirement of the public `LabeledSubject` protocol.
    let accessModifier: String

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
        accessModifier = Self.accessModifier(of: declaration)
        labelsLiteral = "[" + arguments.map(\.expression.trimmedDescription).joined(separator: ", ") + "]"
    }

    private static func accessModifier(of declaration: some DeclGroupSyntax) -> String {
        let keywords = declaration.modifiers.map(\.name.tokenKind)
        if keywords.contains(.keyword(.public)) || keywords.contains(.keyword(.open)) {
            return "public"
        }
        if keywords.contains(.keyword(.package)) {
            return "package"
        }

        return ""
    }
}
