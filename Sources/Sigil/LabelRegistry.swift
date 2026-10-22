/// Enumerates every declaration annotated with ``Labeled(_:)`` in the running process.
///
/// Records live in the `__DATA,__sigil` section of each loaded image, so
/// declarations in dynamic libraries and app extensions are found as long as
/// their image is loaded. Enumeration scans the section on every call.
public enum LabelRegistry {
    /// Every annotated declaration, in no guaranteed order.
    public static func entries() -> [LabelEntry] {
        LabelSection.records().map(entry(from:))
    }

    /// The annotated declarations carrying at least one label of type `L`,
    /// each paired with those labels.
    public static func entries<L: Label>(carrying type: L.Type) -> [(subject: Any.Type, labels: [L])] {
        entries().compactMap { entry in
            let matches = entry.labels(of: type)
            return matches.isEmpty ? nil : (entry.subject, matches)
        }
    }

    private static func entry(from record: LabelRecord) -> LabelEntry {
        let storage = UnsafeMutablePointer<LabelEntry>.allocate(capacity: 1)
        defer { storage.deallocate() }

        record.accessor(UnsafeMutableRawPointer(storage))
        return storage.move()
    }
}
