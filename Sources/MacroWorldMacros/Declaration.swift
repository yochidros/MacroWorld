import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AnimalMacro: DeclarationMacro {

    public static var formatMode: FormatMode = .auto

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let argument = node.argumentList.first?.expression,
            let name = argument.as(StringLiteralExprSyntax.self)?.segments
        else { return [] }
        return [
            .init(
                StructDeclSyntax(
                    //                    modifiers: ModifierListSyntax(arrayLiteral: .init(name: "public"), .init(name: "struct"), .init(name: "\(raw: name.description)")),
                    identifier: .identifier("\(name.description)"),
                    inheritanceClause: .init(
                        inheritedTypeCollection: InheritedTypeListSyntax([
                            InheritedTypeSyntax(typeName: SimpleTypeIdentifierSyntax(name: .identifier("AnimalProtocol")))
                        ])
                    ),
                    memberBlock: MemberDeclBlockSyntax(stringLiteral: "")
                        .with(\.leftBrace, TokenSyntax.leftBraceToken())
                        .addMember(
                            MemberDeclListItemSyntax(
                                decl: DeclSyntax(stringLiteral: "let name: String")
                            )
                        )
                        .addMember(
                            MemberDeclListItemSyntax(
                                decl: FunctionDeclSyntax(
                                    identifier: .identifier("say"),
                                    signature: FunctionSignatureSyntax(
                                        input: ParameterClauseSyntax(
                                            parameterList: FunctionParameterListSyntax([])
                                        )
                                    ),
                                    body: CodeBlockSyntax(
                                        statements: CodeBlockItemListSyntax([
                                            CodeBlockItemSyntax(
                                                item: .expr(
                                                    .init(
                                                        FunctionCallExprSyntax(
                                                            calledExpression: IdentifierExprSyntax(
                                                                identifier: .identifier("print")
                                                            ),
                                                            leftParen: TokenSyntax.leftParenToken(),
                                                            argumentList: .init([
                                                                .init(
                                                                    expression: StringLiteralExprSyntax(
                                                                        content: "Hello"
                                                                    ),
                                                                    trailingComma: .commaToken()
                                                                ),
                                                                .init(
                                                                    expression: IdentifierExprSyntax(
                                                                        identifier: .identifier("name")
                                                                    )
                                                                ),
                                                            ]),
                                                            rightParen: TokenSyntax.rightParenToken()
                                                        )
                                                    )
                                                )
                                            )

                                        ])
                                    )
                                )
                            )
                        )
                        .addMember(
                            MemberDeclListItemSyntax(
                                decl: FunctionDeclSyntax(
                                    identifier: .identifier("sayAgain"),
                                    signature: FunctionSignatureSyntax(
                                        input: ParameterClauseSyntax(
                                            parameterList: FunctionParameterListSyntax([])
                                        )
                                    ),
                                    body: CodeBlockSyntax(
                                        statements: CodeBlockItemListSyntax([
                                            CodeBlockItemSyntax(stringLiteral: "print(\"Hello Again!!\", name)")
                                        ])
                                    )
                                )
                            )
                        )
                        .with(\.rightBrace, TokenSyntax.rightBraceToken())
                )
            )
        ]
    }
}

struct SimpleDiagnosticMessage: DiagnosticMessage {
    let message: String
    let diagnosticID: MessageID
    let severity: DiagnosticSeverity
}

// Copied From: https://github.com/apple/swift-evolution/blob/main/proposals/0397-freestanding-declaration-macros.md
public struct WarningMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let messageExpr = node.argumentList.first?.expression.as(StringLiteralExprSyntax.self),
            messageExpr.segments.count == 1,
            let firstSegment = messageExpr.segments.first,
            case let .stringSegment(message) = firstSegment
        else {
            throw MacroError.warning("warning macro requires a non-interpolated string literal")
        }

        context.diagnose(
            .init(
                node: Syntax(node),
                message: SimpleDiagnosticMessage(
                    message: "🐈 " + message.description,
                    diagnosticID: .init(domain: "🐶", id: "👿"),
                    severity: .warning
                )
            )
        )
        return []
    }
}
