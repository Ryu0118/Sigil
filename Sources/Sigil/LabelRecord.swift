/// Fills `out` with a ``LabelEntry`` and returns. `out` points at
/// uninitialized memory sized and aligned for `LabelEntry`.
public typealias LabelAccessor = @convention(c) (_ out: UnsafeMutableRawPointer) -> Void

/// The constant-expression record `@Labeled` stores in the label section.
///
/// A section initializer cannot hold strings or user types, so the record
/// holds a version tag and a function that builds the entry on demand.
public typealias LabelRecord = (version: UInt32, accessor: LabelAccessor)

/// Namespace for the on-disk record format.
public enum LabelRecordFormat {
    /// Version tag written into every record; readers skip other versions.
    public static let version: UInt32 = 1
}
