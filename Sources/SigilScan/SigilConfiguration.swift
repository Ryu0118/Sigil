import Yams

/// The contents of `.sigil.yml`.
public struct SigilConfiguration: Codable, Equatable, Sendable {
    /// Rules that selected declarations must carry a label of a given type.
    public let requirements: [LabelRequirement]

    /// Parses a configuration document.
    public init(yaml: String) throws {
        self = try YAMLDecoder().decode(Self.self, from: yaml)
    }

    /// Decodes a configuration, treating an omitted `requirements` list as empty.
    public init(from decoder: any Decoder) throws {
        requirements = try decoder.container(keyedBy: CodingKeys.self)
            .decodeIfPresent([LabelRequirement].self, forKey: .requirements) ?? []
    }
}
