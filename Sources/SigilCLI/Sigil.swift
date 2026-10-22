import ArgumentParser

@main
struct Sigil: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sigil",
        abstract: "Scan Swift source for @Labeled declarations.",
        version: SigilVersion.current,
        subcommands: [ScanCommand.self]
    )
}
