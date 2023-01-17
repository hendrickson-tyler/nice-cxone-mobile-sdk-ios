import Foundation


enum PluginMessageTypeMapper {
    
    static func map(_ entity: PluginMessageType) throws -> PluginMessageDTOType {
        switch entity {
        case .gallery(let entities):
            return .gallery(try entities.map(Self.map))
        case .menu(let entity):
            return .menu(PluginMessageMenuMapper.map(entity))
        case .textAndButtons(let entity):
            return .textAndButtons(PluginMessageTextAndButtonsMapper.map(entity))
        case .quickReplies(let entity):
            return .quickReplies(PluginMessageQuickRepliesMapper.map(entity))
        case .satisfactionSurvey(let entity):
            return .satisfactionSurvey(PluginMessageSatisfactionSurveyMapper.map(entity))
        case .subElements(let entities):
            return .subElements(entities.map(PluginMessageSubElementMapper.map))
        case .custom(let entity):
            return .custom(try PluginMessageCustomMapper.map(entity))
        }
    }
    
    static func map(_ entity: PluginMessageDTOType) -> PluginMessageType {
        switch entity {
        case .gallery(let entities):
            return .gallery(entities.map(Self.map))
        case .menu(let entity):
            return .menu(PluginMessageMenuMapper.map(entity))
        case .textAndButtons(let entity):
            return .textAndButtons(PluginMessageTextAndButtonsMapper.map(entity))
        case .quickReplies(let entity):
            return .quickReplies(PluginMessageQuickRepliesMapper.map(entity))
        case .satisfactionSurvey(let entity):
            return .satisfactionSurvey(PluginMessageSatisfactionSurveyMapper.map(entity))
        case .subElements(let entities):
            return .subElements(entities.map(PluginMessageSubElementMapper.map))
        case .custom(let entity):
            return .custom(PluginMessageCustomMapper.map(entity))
        }
    }
}


// MARK: - PluginMessageMenuMapper

private enum PluginMessageMenuMapper {
    
    static func map(_ entity: PluginMessageMenu) -> PluginMessageMenuDTO {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
    
    static func map(_ entity: PluginMessageMenuDTO) -> PluginMessageMenu {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
}


// MARK: - PluginMessageTextAndButtonsMapper

private enum PluginMessageTextAndButtonsMapper {
    
    static func map(_ entity: PluginMessageTextAndButtons) -> PluginMessageTextAndButtonsDTO {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
    
    static func map(_ entity: PluginMessageTextAndButtonsDTO) -> PluginMessageTextAndButtons {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
}


// MARK: - PluginMessageQuickRepliesMapper

private enum PluginMessageQuickRepliesMapper {
    
    static func map(_ entity: PluginMessageQuickReplies) -> PluginMessageQuickRepliesDTO {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
    
    static func map(_ entity: PluginMessageQuickRepliesDTO) -> PluginMessageQuickReplies {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
}


// MARK: - PluginMessageSatisfactionSurveyMapper

private enum PluginMessageSatisfactionSurveyMapper {
    
    static func map(_ entity: PluginMessageSatisfactionSurvey) -> PluginMessageSatisfactionSurveyDTO {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
    
    static func map(_ entity: PluginMessageSatisfactionSurveyDTO) -> PluginMessageSatisfactionSurvey {
        .init(id: entity.id, elements: entity.elements.map(PluginMessageSubElementMapper.map))
    }
}


// MARK: - PluginMessageCustomMapper

private enum PluginMessageCustomMapper {
    
    static func map(_ entity: PluginMessageCustomDTO) -> PluginMessageCustom {
        var variables = [String: Any]()
        
        for (key, value) in entity.variables {
            variables[key] = CodableObjectMapper.map(value)
        }
        
        return .init(id: entity.id, text: entity.text, variables: variables)
    }
    
    static func map(_ entity: PluginMessageCustom) throws -> PluginMessageCustomDTO {
        var variables = [String: CodableObject]()
        
        for (key, value) in entity.variables {
            variables[key] = try CodableObjectMapper.map(value)
        }
        
        return .init(id: entity.id, text: entity.text, variables: variables)
    }
}

// MARK: - CodableObjectMapper

private enum CodableObjectMapper {
    
    static func map(_ entity: CodableObject) -> Any {
        switch entity {
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .bool(let value):
            return value
        case .dictionary(let dictionary):
            var variables = [String: Any]()
            
            for (key, value) in dictionary {
                variables[key] = Self.map(value)
            }
            
            return variables
        case .array(let array):
            return array.map { Self.map($0) }
        }
    }
    
    static func map(_ entity: Any) throws -> CodableObject {
        switch entity {
        case let value as Bool where entity is Bool:
            return .bool(value)
        case let value as String where entity is String:
            return .string(value)
        case let value as Int where entity is Int:
            return .int(value)
        case let value as Double where entity is Double:
            return .double(value)
        case let dictionary as [String: Any] where entity is [String: Any]:
            var result = [String: CodableObject]()
            
            for (key, value) in dictionary {
                result[key] = try Self.map(value)
            }
            
            return .dictionary(result)
        case let array as [Any] where entity is [Any]:
            return try .array(array.map { try Self.map($0) })
        default:
            throw CXoneChatError.invalidData
        }
    }
}
