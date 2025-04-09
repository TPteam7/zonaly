//
//  LocationData.swift
//  zonaly
//
//  Created by Trevor Pope on 4/1/25.
//

import Foundation
import CoreLocation
import FamilyControls

struct SavedLocation: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var coordinate: CLLocationCoordinate2D
    var radius: Double
    var activitySelectionData: Data?

    /// Computed property to access decoded FamilyActivitySelection
    var activitySelection: FamilyActivitySelection? {
        guard let data = activitySelectionData else { return nil }
        return try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    }

    /// Initialize from existing selection
    init(id: UUID = UUID(), name: String, coordinate: CLLocationCoordinate2D, radius: Double, activitySelection: FamilyActivitySelection?) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.radius = radius
        self.activitySelectionData = try? JSONEncoder().encode(activitySelection)
    }

    /// Optional equality override (excluding `activitySelection` because it's a computed property)
    static func == (lhs: SavedLocation, rhs: SavedLocation) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate == rhs.coordinate &&
        lhs.radius == rhs.radius &&
        lhs.activitySelectionData == rhs.activitySelectionData
    }
}

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
