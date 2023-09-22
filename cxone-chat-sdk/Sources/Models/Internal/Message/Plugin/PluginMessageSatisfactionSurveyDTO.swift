import Foundation

struct PluginMessageSatisfactionSurveyDTO {
    
    // MARK: - Properties
    
    let id: String
    
    let elements: [PluginMessageSubElementDTOType]
    
    // MARK: - Init
    
    init(id: String, elements: [PluginMessageSubElementDTOType]) {
        self.id = id
        self.elements = elements
    }
}

// MARK: - Codable

extension PluginMessageSatisfactionSurveyDTO: Codable {
    
    enum CodingKeys: CodingKey {
        case id
        case type
        case elements
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard try container.decode(ElementType.self, forKey: .type) == .satisfactionSurvey else {
            throw DecodingError.typeMismatch(
                ElementType.self,
                DecodingError.Context(codingPath: container.codingPath, debugDescription: "PluginMessageSatisfactionSurveyDTO")
            )
        }
        
        self.id = try container.decode(String.self, forKey: .id)
        self.elements = try container.decode([PluginMessageSubElementDTOType].self, forKey: .elements)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(ElementType.satisfactionSurvey.rawValue, forKey: .type)
        try container.encode(elements, forKey: .elements)
    }
}