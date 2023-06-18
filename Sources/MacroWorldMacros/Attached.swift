import Foundation
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AccessorChronoMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        return [
            .init(
                accessorKind: .keyword(.get),
                body: .init(
                    statements: .init([
                        CodeBlockItemSyntax(
                            item: .expr(
                                .init(
                                    FunctionCallExprSyntax(
                                        calledExpression: IdentifierExprSyntax(
                                            identifier: .identifier("print")
                                        ),
                                        leftParen: .leftParenToken(),
                                        argumentList: .init([
                                            .init(expression: StringLiteralExprSyntax(content: "get called!! wooooo"))
                                        ]),
                                        rightParen: .rightParenToken()
                                    )
                                )
                            )
                        ),
                        CodeBlockItemSyntax(
                            item: .stmt(.init(ReturnStmtSyntax(expression: IdentifierExprSyntax(identifier: .identifier("_name")))))
                        ),
                    ])
                )
            ),
            .init(
                accessorKind: .keyword(.set),
                body: .init(
                    statements: .init([
                        CodeBlockItemSyntax(
                            item: .expr(
                                .init(
                                    FunctionCallExprSyntax(
                                        calledExpression: IdentifierExprSyntax(identifier: .identifier("print")),
                                        leftParen: .leftParenToken(),
                                        argumentList: .init([
                                            .init(
                                                expression: StringLiteralExprSyntax(
                                                    openQuote: .stringQuoteToken(),
                                                    segments: .init([
                                                        .stringSegment(StringSegmentSyntax(content: "set newValue woooooooooo")),
                                                        .expressionSegment(
                                                            .init(
                                                                backslash: .backslashToken(),
                                                                leftParen: .leftParenToken(),
                                                                expressions: .init([
                                                                    .init(
                                                                        expression: IdentifierExprSyntax(
                                                                            identifier: .identifier("newValue")
                                                                        )
                                                                    )
                                                                ]),
                                                                rightParen: .rightParenToken()
                                                            )
                                                        ),
                                                    ]),
                                                    closeQuote: .stringQuoteToken()
                                                )
                                            )
                                        ]),
                                        rightParen: .rightParenToken()
                                    )
                                )
                            )
                        ),

                        CodeBlockItemSyntax(
                            item: .expr(
                                .init(
                                    SequenceExprSyntax(
                                        elements: .init([
                                            IdentifierExprSyntax(identifier: .identifier("_name")),
                                            AssignmentExprSyntax(),
                                            IdentifierExprSyntax(identifier: .identifier("newValue")),
                                        ])
                                    )
                                )
                            )
                        ),
                    ])
                )
            ),
        ]
    }

}
