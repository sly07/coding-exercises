//
//  LocationModel.swift
//  Locations
//
//  Created by Mike Sly on 10/8/24.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let attributes: [Attribute]
    
    let locationType: LocationType

    // Computed property to get the coordinate
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var name: String {
        attributes.first { $0.type == "name" }?.value ?? ""
    }
    
    var description: String {
        attributes.first { $0.type == "description" }?.value ?? ""
    }
    
    var estimatedRevenueMillions: Double {
        Double(attributes.first { $0.type == "estimated_revenue_millions" }?.value ?? "0") ?? 0.0
    }
    
    // Custom initializer to decode locationType from attributes
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        attributes = try container.decode([Attribute].self, forKey: .attributes)

        // Extract locationType from attributes array
        if let typeString = attributes.first(where: { $0.type == "location_type" })?.value {
            locationType = LocationType(rawValue: typeString) ?? .unknown
        } else {
            locationType = .unknown
        }
    }

    // Coding keys for decoding
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case attributes
    }
}

struct Attribute: Codable {
    let type: String
    let value: String
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        
        // Try to decode `value` as a String first, then try as a Double
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
    
    
}
