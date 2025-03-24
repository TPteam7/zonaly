// 📍 RestrictedRegion.swift
import Foundation
import CoreLocation
import FamilyControls

struct RestrictedRegion: Identifiable, Codable {
    let id: UUID
    var center: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var restriction: FamilyActivitySelection

    enum CodingKeys: String, CodingKey {
        case id, centerLat, centerLon, radius, restriction
    }

    // Custom Codable handling for CLLocationCoordinate2D
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let lat = try container.decode(Double.self, forKey: .centerLat)
        let lon = try container.decode(Double.self, forKey: .centerLon)
        center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        radius = try container.decode(Double.self, forKey: .radius)
        restriction = try container.decode(FamilyActivitySelection.self, forKey: .restriction)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(center.latitude, forKey: .centerLat)
        try container.encode(center.longitude, forKey: .centerLon)
        try container.encode(radius, forKey: .radius)
        try container.encode(restriction, forKey: .restriction)
    }

    init(id: UUID = UUID(), center: CLLocationCoordinate2D, radius: CLLocationDistance, restriction: FamilyActivitySelection) {
        self.id = id
        self.center = center
        self.radius = radius
        self.restriction = restriction
    }
}
