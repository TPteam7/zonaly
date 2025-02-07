import CoreLocation

class LocationChecker: ObservableObject {
    @Published var regionCenter: CLLocation?
    @Published var regionRadius: CLLocationDistance = 100 // Default 1km radius

    func setRegionCenter(latitude: Double, longitude: Double) {
        self.regionCenter = CLLocation(latitude: latitude, longitude: longitude)
    }

    func setRegionRadius(_ radius: CLLocationDistance) {
        self.regionRadius = radius
    }

    func isInsideRegion(userLocation: CLLocation) -> Bool {
        guard let center = regionCenter else { return false }
        let distance = userLocation.distance(from: center)
        return distance <= regionRadius
    }

    func formattedDistanceFromRegion(userLocation: CLLocation) -> String {
        guard let center = regionCenter else { return "Region not set" }
        let distance = userLocation.distance(from: center)
        return String(format: "%.2f meters", distance)
    }
}
