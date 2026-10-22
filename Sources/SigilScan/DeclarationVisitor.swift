import SwiftSyntax

/// Walks a syntax tree and records every nominal declaration with its labels.
final class DeclarationVisitor: SyntaxVisitor {
    private let path: String
    private let converter: SourceLocationConverter
    private var scope: [String] = []
    private(set) var declarations: [ScannedDeclaration] = []

    init(path: String, tree: SourceFileSyntax) {
        self.path = path
        converter = SourceLocationConverter(fileName: path, tree: tree)
        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        enter(node, name: node.name.text, kind: "struct", inheritance: node.inheritanceClause)
    }

    override func visitPost(_: StructDeclSyntax) {
        scope.removeLast()
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        enter(node, name: node.name.text, kind: "class", inheritance: node.inheritanceClause)
    }

    override func visitPost(_: ClassDeclSyntax) {
        scope.removeLast()
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        enter(node, name: node.name.text, kind: "enum", inheritance: node.inheritanceClause)
    }

    override func visitPost(_: EnumDeclSyntax) {
        scope.removeLast()
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        enter(node, name: node.name.text, kind: "actor", inheritance: node.inheritanceClause)
    }

    override func visitPost(_: ActorDeclSyntax) {
        scope.removeLast()
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        scope.append(node.extendedType.trimmedDescription)
        return .visitChildren
    }

    override func visitPost(_: ExtensionDeclSyntax) {
        scope.removeLast()
    }

    private func enter(
        _ node: some DeclGroupSyntax,
        name: String,
        kind: String,
        inheritance: InheritanceClauseSyntax?
    ) -> SyntaxVisitorContinueKind {
        let attributes = node.attributes.compactMap { $0.as(AttributeSyntax.self) }
        let isLabeled: (AttributeSyntax) -> Bool = { ["Labeled", "Sigil.Labeled"].contains($0.attributeName.trimmedDescription) }

        declarations.append(
            ScannedDeclaration(
                name: (scope + [name]).joined(separator: "."),
                kind: kind,
                path: path,
                line: converter.location(for: node.positionAfterSkippingLeadingTrivia).line,
                inheritedTypes: inheritance?.inheritedTypes.map(\.type.trimmedDescription) ?? [],
                attributes: attributes.filter { !isLabeled($0) }.map(\.attributeName.trimmedDescription),
                labels: attributes.filter(isLabeled).flatMap(LabelExpressionParser.labels(in:))
            )
        )
        scope.append(name)
        return .visitChildren
    }
}
