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

    // Computed property to get the coordinate
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Helper methods to access specific attributes
    var locationType: String {
        attributes.first { $0.type == "location_type" }?.value ?? ""
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
