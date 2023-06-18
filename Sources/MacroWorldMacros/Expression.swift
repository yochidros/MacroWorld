import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

public struct IntifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            let argument = node.argumentList.first?.expression,
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments
        else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        guard let _ = Int(segments.description) else {
            throw MacroError.cannotConvertInt(segments.description)
        }

        return "Int(\(argument))!"
    }
}
public struct URLMacro: ExpressionMacro {
    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> ExprSyntax
    where Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext {
        guard
            let argument = node.argumentList.first?.expression,
            let segment = argument.as(StringLiteralExprSyntax.self)?.segments
        else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        let str = segment.description
        guard let _ = URL(string: str) else {
            throw MacroError.malformedURL(str)
        }
        return "URL(string: \(argument))!"
    }
}
public struct ValidatedURLMacro: ExpressionMacro {
    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> ExprSyntax
    where Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext {
        guard
            let argument = node.argumentList.first?.expression,
            let segment = argument.as(StringLiteralExprSyntax.self)?.segments
        else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        let str = segment.description

        guard let u = URL(string: str) else {
            throw MacroError.malformedURL("\(str)")
        }

        let strictMode: Bool
        if let v = node.argumentList.last?.expression,
            let strict = v.as(BooleanLiteralExprSyntax.self)?.booleanLiteral
        {
            strictMode = strict.text == "true"
        } else {
            strictMode = true
        }

        if strictMode,
            u.host() == nil || u.scheme == nil
        {
            throw MacroError.malformedURL("No Host or scheme \(argument)")
        }
        return "URL(string: \(argument))!"
    }
}
