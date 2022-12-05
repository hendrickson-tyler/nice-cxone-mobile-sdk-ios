import Foundation


// MessageCreated

/// Event Received when a message has been successfully sent/created.
struct MessageCreatedEventDTO: ReceivedEvent, Codable {
    
    // MARK: - Properties

    /// The unique identifier of the event.
    let eventId: UUID

    /// The objects for which an event is applicable.
    let eventObject: EventObjectType

    /// The type of the event.
    let eventType: EventType

    /// The timestamp of when the message was created.
    let createdAt: Date

    /// Data of the message created event.
    let data: MessageCreatedEventDataDTO


    // MARK: - Init
    
    init(eventId: UUID, eventObject: EventObjectType, eventType: EventType, createdAt: Date, data: MessageCreatedEventDataDTO) {
        self.eventId = eventId
        self.eventObject = eventObject
        self.eventType = eventType
        self.createdAt = createdAt
        self.data = data
    }
    
    
    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case eventId
        case eventObject
        case eventType
        case createdAt
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.eventId = try container.decode(UUID.self, forKey: .eventId)
        self.eventObject = try container.decode(EventObjectType.self, forKey: .eventObject)
        self.eventType = try container.decode(EventType.self, forKey: .eventType)
        self.createdAt = try container.decodeISODate(forKey: .createdAt)
        self.data = try container.decode(MessageCreatedEventDataDTO.self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(eventId, forKey: .eventId)
        try container.encode(eventObject, forKey: .eventObject)
        try container.encode(eventType, forKey: .eventType)
        try container.encodeISODate(createdAt, forKey: .createdAt)
        try container.encode(data, forKey: .data)
    }
}
