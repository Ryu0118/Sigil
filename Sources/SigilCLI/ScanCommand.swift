import ArgumentParser
import Foundation
import SigilScan

struct ScanCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "scan",
        abstract: "Print every nominal declaration with its labels as JSON."
    )

    @OptionGroup var options: RootOptions

    func run() throws {
        let declarations = try SourceTreeScanner.scan(
            root: options.rootURL,
            skipping: SourceTreeScanner.defaultSkippedDirectories + options.skip
        )
        try print(JSONOutput.string(declarations))
    }
}
