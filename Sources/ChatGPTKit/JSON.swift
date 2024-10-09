public enum JSONSchemaType: String, Codable {
    case object
    case string
    case integer
    case number
    case boolean
}

public struct JSONSchemaProperty: Codable {
    public let type: JSONSchemaType
    public let format: String?
    public let description: String?
    public let enumValues: [String]?  // For enum types
    
    public init(type: JSONSchemaType, format: String?, description: String?, enumValues: [String]?) {
        self.type = type
        self.format = format
        self.description = description
        self.enumValues = enumValues
    }
    
    public enum CodingKeys: String, CodingKey {
        case type
        case format
        case description
        case enumValues = "enum"
    }
}

public struct JSONParameters: Codable {
    public let type: JSONSchemaType
    public let properties: [String: JSONSchemaProperty]
    public let additionalProperties: Bool
    public let required: [String]
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case additionalProperties = "additionalProperties"
        case required
    }
    
    public init(
        type: JSONSchemaType,
        properties: [String: JSONSchemaProperty],
        required: [String],
        additionalProperties: Bool = false
    ) {
        self.type = type
        self.properties = properties
        self.required = required
        self.additionalProperties = additionalProperties
    }
}

public struct JSONSchema: Codable {
    public let name: String
    public let strict: Bool
    public let schema: JSONParameters
    
    public init(name: String, strict: Bool = true, schema: JSONParameters) {
        self.name = name
        self.strict = strict
        self.schema = schema
    }
}

public struct ResponseFormat: Codable {
    let type = "json_schema"
    let json_schema: JSONSchema
    
    public init(json_schema: JSONSchema) {
        self.json_schema = json_schema
    }
}
