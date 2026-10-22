import ArgumentParser

@main
struct Sigil: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sigil",
        abstract: "Scan Swift source for @Labeled declarations, check coverage and export manifests.",
        subcommands: [ScanCommand.self, CheckCommand.self, ManifestCommand.self]
    )
}
