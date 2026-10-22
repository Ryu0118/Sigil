import ArgumentParser

@main
struct Sigil: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sigil",
        abstract: "Scan Swift source for @Labeled declarations, check coverage and export manifests.",
        version: SigilVersion.current,
        subcommands: [ScanCommand.self, CheckCommand.self, ManifestCommand.self]
    )
}
