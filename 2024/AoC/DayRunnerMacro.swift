import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RunnerMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {

        return [
            "let answeringFunc = day",
            "static func main() async { await Self().runDay() }"
        ]
    }
}

@main
struct RunnerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RunnerMacro.self,
    ]
}
