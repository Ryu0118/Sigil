import ArgumentParser
import Foundation
import SigilScan

struct ManifestCommand: ParsableCommand {
    enum Format: String, ExpressibleByArgument {
        case json, names
    }

    static let configuration = CommandConfiguration(
        commandName: "manifest",
        abstract: "Export one label argument (for example every screen name) and fail on duplicates or drift."
    )

    @OptionGroup var options: RootOptions

    @Option(name: .long, help: "Label type to export, for example ScreenLabel.")
    var label: String

    @Option(name: .long, help: "Argument of the label to export, for example name.")
    var argument: String

    @Option(name: .long, help: "json prints entries with locations; names prints one value per line.")
    var format: Format = .names

    @Option(name: .long, help: "File with one expected value per line; exit non-zero when code and file differ.")
    var expected: String?

    func run() throws {
        let declarations = try SourceTreeScanner.scan(
            root: options.rootURL,
            skipping: SourceTreeScanner.defaultSkippedDirectories + options.skip
        )
        let manifest = Manifest(declarations: declarations, label: label, argument: argument)

        switch format {
        case .json: try print(JSONOutput.string(manifest))
        case .names: Set(manifest.entries.map(\.value)).sorted().forEach { print($0) }
        }
        try verify(manifest)
    }

    private func verify(_ manifest: Manifest) throws {
        let duplicates = manifest.duplicates
        duplicates.forEach { FileHandle.standardError.write(Data("error: \(label).\(argument) \"\($0.value)\" is used by \($0.subjects.joined(separator: ", "))\n".utf8)) }

        let difference = try expected.map { path in
            try manifest.compare(toExpected: Set(String(contentsOfFile: path, encoding: .utf8).split(separator: "\n").map(String.init)))
        }
        difference?.missingFromCode.forEach { FileHandle.standardError.write(Data("error: expected \(label).\(argument) \"\($0)\" has no @Labeled declaration\n".utf8)) }
        difference?.notExpected.forEach { FileHandle.standardError.write(Data("error: \(label).\(argument) \"\($0)\" is not in the expected set\n".utf8)) }

        if !duplicates.isEmpty || difference?.isEmpty == false {
            throw ExitCode.failure
        }
    }
}
