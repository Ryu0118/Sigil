import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SigilPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [LabeledMacro.self]
}
