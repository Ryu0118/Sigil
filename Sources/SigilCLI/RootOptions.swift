import ArgumentParser
import Foundation

/// Options shared by every command that reads a source tree.
struct RootOptions: ParsableArguments {
    @Option(name: .long, help: "Directory to scan; reported paths are relative to it.")
    var root: String = "."

    @Option(name: .long, parsing: .upToNextOption, help: "Extra directory names to skip, in addition to build and dependency folders.")
    var skip: [String] = []

    var rootURL: URL {
        URL(filePath: root, directoryHint: .isDirectory)
    }
}
