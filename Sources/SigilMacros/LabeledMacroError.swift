/// Diagnostics for invalid `@Labeled` uses.
enum LabeledMacroError: Error, CustomStringConvertible {
    case unsupportedDeclaration
    case genericDeclaration
    case missingLabels

    var description: String {
        switch self {
        case .unsupportedDeclaration:
            "@Labeled applies to structs, classes, enums and actors"
        case .genericDeclaration:
            "@Labeled cannot be applied to a generic type because a section record cannot name an unspecialized type"
        case .missingLabels:
            "@Labeled needs at least one label"
        }
    }
}
