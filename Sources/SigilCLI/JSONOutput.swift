import Foundation

/// Stable JSON rendering so manifests diff cleanly in version control.
enum JSONOutput {
    static func string(_ value: some Encodable) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return try String(decoding: encoder.encode(value), as: UTF8.self)
    }
}
