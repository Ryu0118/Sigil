#if canImport(Darwin)
    import MachO
#endif

/// Reads the raw records `@Labeled` stores in the label section of every loaded image.
enum LabelSection {
    /// Returns every record of the current format across all loaded images.
    static func records() -> [LabelRecord] {
        #if canImport(Darwin)
            (0 ..< _dyld_image_count()).flatMap(records(inImageAt:))
        #else
            []
        #endif
    }

    #if canImport(Darwin)
        private static func records(inImageAt index: UInt32) -> [LabelRecord] {
            guard let header = _dyld_get_image_header(index) else { return [] }

            let machHeader = UnsafeRawPointer(header).assumingMemoryBound(to: mach_header_64.self)
            var byteCount: UInt = 0
            guard let start = getsectiondata(machHeader, "__DATA", "__sigil", &byteCount) else { return [] }

            let stride = MemoryLayout<LabelRecord>.stride
            let raw = UnsafeRawPointer(start)
            return (0 ..< Int(byteCount) / stride)
                .map { raw.load(fromByteOffset: $0 * stride, as: LabelRecord.self) }
                .filter { $0.version == LabelRecordFormat.version }
        }
    #endif
}
