import SwiftSyntax

/// Turns the expressions inside `@Labeled(...)` into ``ScannedLabel`` values.
enum LabelExpressionParser {
    static func labels(in attribute: AttributeSyntax) -> [ScannedLabel] {
        guard case let .argumentList(arguments) = attribute.arguments else { return [] }

        return arguments.map { label(from: $0.expression) }
    }

    private static func label(from expression: ExprSyntax) -> ScannedLabel {
        guard let call = expression.as(FunctionCallExprSyntax.self) else {
            return ScannedLabel(type: expression.trimmedDescription, arguments: [:])
        }

        let pairs = call.arguments.enumerated().map { index, argument in
            (argument.label?.text ?? "_\(index)", value(of: argument.expression))
        }
        return ScannedLabel(
            type: call.calledExpression.trimmedDescription,
            arguments: Dictionary(pairs, uniquingKeysWith: { first, _ in first })
        )
    }

    private static func value(of expression: ExprSyntax) -> String {
        guard
            let literal = expression.as(StringLiteralExprSyntax.self),
            literal.segments.count == 1,
            let segment = literal.segments.first?.as(StringSegmentSyntax.self)
        else {
            return expression.trimmedDescription
        }

        return segment.content.text
    }
}
