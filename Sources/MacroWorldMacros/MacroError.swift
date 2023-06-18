enum MacroError: Error, CustomStringConvertible {
    case malformedURL(String)
    case cannotConvertInt(String)
    case warning(String)

    var description: String {
        switch self {
        case let .malformedURL(u):
            "MacroError: Malformed URL: \(u)"
        case let .cannotConvertInt(v):
            "MacroError: Cannot Convert to Int because Not number of String `\(v)`"
        case let .warning(message):
            "MacroError: \(message)"
        }
    }
}
