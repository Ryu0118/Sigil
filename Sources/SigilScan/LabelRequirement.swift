/// A rule saying that matching declarations must carry a label of one type.
public struct LabelRequirement: Codable, Equatable, Sendable {
    /// The label type every matching declaration must carry, for example `ScreenLabel`.
    public let label: String

    /// A declaration matches when it lists any of these in its inheritance clause.
    public let conformsTo: [String]

    /// A declaration also matches when it has any of these attributes, such as `Reducer`.
    public let attributes: [String]

    /// Glob patterns of files the requirement applies to. Empty means every file.
    public let include: [String]

    /// Glob patterns of files the requirement skips.
    public let exclude: [String]

    /// Creates a requirement.
    public init(
        label: String,
        conformsTo: [String] = [],
        attributes: [String] = [],
        include: [String] = [],
        exclude: [String] = []
    ) {
        self.label = label
        self.conformsTo = conformsTo
        self.attributes = attributes
        self.include = include
        self.exclude = exclude
    }

    /// Decodes a requirement, treating omitted lists as empty.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decode(String.self, forKey: .label)
        conformsTo = try container.decodeIfPresent([String].self, forKey: .conformsTo) ?? []
        attributes = try container.decodeIfPresent([String].self, forKey: .attributes) ?? []
        include = try container.decodeIfPresent([String].self, forKey: .include) ?? []
        exclude = try container.decodeIfPresent([String].self, forKey: .exclude) ?? []
    }
}
