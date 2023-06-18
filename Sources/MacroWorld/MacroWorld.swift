// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
import Foundation

@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "MacroWorldMacros", type: "StringifyMacro")

@freestanding(expression)
public macro intify(_ stringLiteral: String) -> Int = #externalMacro(
  module: "MacroWorldMacros", type: "IntifyMacro")

@freestanding(expression)
public macro url(_ stringLiteral: String) -> URL = #externalMacro(
  module: "MacroWorldMacros", type: "URLMacro")

@freestanding(expression)
public macro
validatedURL(_ stringLiteral: String, strict: Bool = true)
  -> URL = #externalMacro(module: "MacroWorldMacros", type: "ValidatedURLMacro")

@freestanding(declaration)
public macro customWarning(_ message: String) = #externalMacro(module: "MacroWorldMacros", type: "WarningMacro")

@freestanding(declaration, names: arbitrary)
public macro Animal(typeName: String) = #externalMacro(module: "MacroWorldMacros", type: "AnimalMacro")

public protocol AnimalProtocol {
    func say()
    func sayAgain()
}
