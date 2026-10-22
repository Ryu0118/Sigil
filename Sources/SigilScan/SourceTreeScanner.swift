import Foundation

/// Scans every Swift file under a directory.
public enum SourceTreeScanner {
    /// Directory names skipped by default: build output and dependency checkouts.
    public static let defaultSkippedDirectories = [".build", ".swiftpm", "Pods", "Carthage", "DerivedData", "node_modules"]

    /// Scans `root` recursively and returns declarations ordered by path, then source order.
    ///
    /// - Parameters:
    ///   - root: The directory to scan; recorded paths are relative to it.
    ///   - skipping: Directory names not to descend into.
    public static func scan(
        root: URL,
        skipping: [String] = defaultSkippedDirectories
    ) throws -> [ScannedDeclaration] {
        try swiftFiles(under: root, skipping: Set(skipping))
            .sorted { $0.relativePath < $1.relativePath }
            .flatMap { file in
                try DeclarationScanner.scan(source: String(contentsOf: file.url, encoding: .utf8), path: file.relativePath)
            }
    }

    private static func swiftFiles(under root: URL, skipping: Set<String>) -> [(url: URL, relativePath: String)] {
        let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.isDirectoryKey])
        var files: [(URL, String)] = []
        while let url = enumerator?.nextObject() as? URL {
            skipDescendantsIfExcluded(url, enumerator: enumerator, skipping: skipping)
            files += swiftFile(at: url, root: root)
        }
        return files
    }

    private static func skipDescendantsIfExcluded(_ url: URL, enumerator: FileManager.DirectoryEnumerator?, skipping: Set<String>) {
        guard skipping.contains(url.lastPathComponent) else { return }

        enumerator?.skipDescendants()
    }

    private static func swiftFile(at url: URL, root: URL) -> [(URL, String)] {
        url.pathExtension == "swift" ? [(url, relativePath(of: url, from: root))] : []
    }

    private static func relativePath(of url: URL, from root: URL) -> String {
        String(url.standardizedFileURL.path.dropFirst(root.standardizedFileURL.path.count + 1))
    }
}
