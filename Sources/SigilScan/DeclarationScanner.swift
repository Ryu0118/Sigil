import SwiftParser

/// Finds nominal declarations and their `@Labeled` labels in Swift source text.
public enum DeclarationScanner {
    /// Parses `source` and returns its declarations in source order.
    ///
    /// - Parameters:
    ///   - source: Swift source text.
    ///   - path: Recorded on each declaration; the file is not read.
    public static func scan(source: String, path: String) -> [ScannedDeclaration] {
        let tree = Parser.parse(source: source)
        let visitor = DeclarationVisitor(path: path, tree: tree)
        visitor.walk(tree)
        return visitor.declarations
    }
}
