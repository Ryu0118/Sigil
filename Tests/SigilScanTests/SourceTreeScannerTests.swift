import Foundation
@testable import SigilScan
import Testing

@Suite("scans a directory tree of Swift files with root-relative paths")
struct SourceTreeScannerTests {
    private func makeTree(_ files: [String: String]) throws -> URL {
        let root = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        for (path, contents) in files {
            let url = root.appending(path: path)
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try contents.write(to: url, atomically: true, encoding: .utf8)
        }
        return root
    }

    @Test("reads only .swift files and records root-relative paths")
    func readsSwiftFilesOnly() throws {
        let root = try makeTree([
            "Sources/App/Home.swift": "struct Home {}",
            "Sources/App/notes.txt": "struct NotSwift {}",
        ])
        defer { try? FileManager.default.removeItem(at: root) }

        let declarations = try SourceTreeScanner.scan(root: root)

        #expect(declarations.map(\.name) == ["Home"])
        #expect(declarations.first?.path == "Sources/App/Home.swift")
    }

    @Test("skips build and hidden directories")
    func skipsBuildDirectories() throws {
        let root = try makeTree([
            "Sources/A.swift": "struct A {}",
            ".build/B.swift": "struct B {}",
            "Pods/C.swift": "struct C {}",
        ])
        defer { try? FileManager.default.removeItem(at: root) }

        let names = try SourceTreeScanner.scan(root: root, skipping: [".build", "Pods"]).map(\.name)

        #expect(names == ["A"])
    }

    @Test("orders results by path so output is deterministic")
    func ordersByPath() throws {
        let root = try makeTree(["b/Z.swift": "struct Z {}", "a/Y.swift": "struct Y {}"])
        defer { try? FileManager.default.removeItem(at: root) }

        #expect(try SourceTreeScanner.scan(root: root).map(\.name) == ["Y", "Z"])
    }
}
