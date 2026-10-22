import ArgumentParser
import Foundation
import SigilScan

struct CheckCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "check",
        abstract: "Fail when a declaration selected by .sigil.yml lacks its required label."
    )

    @OptionGroup var options: RootOptions

    @Option(name: .long, help: "Configuration file, relative to --root unless absolute.")
    var config: String = ".sigil.yml"

    func run() throws {
        let configURL = URL(filePath: config, relativeTo: options.rootURL)
        let configuration = try SigilConfiguration(yaml: String(contentsOf: configURL, encoding: .utf8))
        let declarations = try SourceTreeScanner.scan(
            root: options.rootURL,
            skipping: SourceTreeScanner.defaultSkippedDirectories + options.skip
        )

        let violations = RequirementChecker.violations(in: declarations, against: configuration.requirements)
        violations.forEach { print($0.diagnostic) }
        if !violations.isEmpty {
            throw ExitCode.failure
        }
    }
}
