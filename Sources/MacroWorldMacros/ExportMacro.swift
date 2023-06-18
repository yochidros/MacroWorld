import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

@main
struct MacroWorldPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        IntifyMacro.self,
        URLMacro.self,
        ValidatedURLMacro.self,
        AnimalMacro.self,
        WarningMacro.self,
    ]
}
