//
//  LocationModel.swift
//  Locations
//
//  Created by Mike Sly on 10/8/24.
//

import Foundation
import MapKit

// MARK: - Location
struct Location: Identifiable, Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let attributes: [Attribute]

    /// These attributes are assigned on initialization from the attributes property.
    /// We assign them on initialization so that we only iterate on the attributes array once for each property.
    /// The drawback is that if we continue to add more attributes, this could get a bit unruly.
    let locationType: LocationType
    let coordinate: CLLocationCoordinate2D
    let name: String
    let description: String
    let estimatedRevenueMillions: Double
    
    // MARK: Init from decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        attributes = try container.decode([Attribute].self, forKey: .attributes)

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        name = attributes.first { $0.type == "name" }?.value ?? ""
        description = attributes.first { $0.type == "description" }?.value ?? ""
        estimatedRevenueMillions = Double(attributes.first { $0.type == "estimated_revenue_millions" }?.value ?? "0") ?? 0.0

        if let typeString = attributes.first(where: { $0.type == "location_type" })?.value {
            locationType = LocationType(rawValue: typeString) ?? .unknown
        } else {
            locationType = .unknown
        }
    }
    
    // MARK: Encode to encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(attributes, forKey: .attributes)
        
        // We do not need to encode `coordinate`, `name`, `description`, or `estimatedRevenueMillions`
        // directly as they are derived from other properties.
    }
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case attributes
    }
}


// MARK: - Attribute
struct Attribute: Codable {
    let type: String
    let value: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        
        /// This logic allows us to treat all attribute values with the same String type. If there is a need to utilize Double values
        /// for logic, we might consider an enum type for the value. However, this adds complexity at the View requiring it to switch on the value type.
        if let stringValue = try? container.decode(String.self, forKey: .value) {
            value = stringValue
        } else if let doubleValue = try? container.decode(Double.self, forKey: .value) {
            value = String(doubleValue)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected to decode String or Double for 'value'"
            ))
        }
    }
}

// MARK: - LocationType
enum LocationType: String, Codable, CaseIterable {
    case bar
    case cafe
    case landmark
    case park
    case museum
    case restaurant

    // Fallback case for unrecognized values
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        // Attempt to initialize from the raw string value, fallback to unknown if invalid
        self = LocationType(rawValue: rawValue) ?? .unknown
    }
    
    func displayName() -> String {
        switch self {
        case .bar:
            "Bar"
        case .cafe:
            "Cafe"
        case .landmark:
            "Landmark"
        case .park:
            "Park"
        case .museum:
            "Museum"
        case .restaurant:
            "Restaurant"
        case .unknown:
            ""
        }
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
