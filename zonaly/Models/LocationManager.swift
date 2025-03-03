import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userLocation: CLLocation?
    
    @Published var regionCenter: CLLocationCoordinate2D?
    @Published var regionRadius: CLLocationDistance = 100  // Default to 100 meters

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10 // Update only when moving 10+ meters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        
        // Fetch last known location if available
        if let lastLocation = locationManager.location {
            self.userLocation = lastLocation
        }

        startLocationUpdates()
    }

    // MARK: - Location Updates

    private func startLocationUpdates() {
        print("Starting location updates...")
        locationManager.startUpdatingLocation()
    }

    private func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Region Monitoring

    func setRegionCenter(latitude: Double, longitude: Double) {
        self.regionCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func setRegionRadius(_ radius: CLLocationDistance) {
        self.regionRadius = radius
    }

    func isInsideRegion(userLocation: CLLocation) -> Bool {
        guard let center = regionCenter else { return false }
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        return userLocation.distance(from: centerLocation) <= regionRadius
    }

    private func handleRegionCheck(for userLocation: CLLocation) {
        if isInsideRegion(userLocation: userLocation) {
            print("✅ User inside region, applying restrictions.")
            FamilyControlsManager.shared.applyRestrictions()
        } else {
            print("❌ User outside region, removing restrictions.")
            FamilyControlsManager.shared.removeRestrictions()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.startLocationUpdates()
            case .denied, .restricted:
                self.stopLocationUpdates()
            default:
                break
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            print("📍 Updated Location: \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
            
            // 🚀 Ensure UI Recognizes Change
            self.userLocation = CLLocation(latitude: latestLocation.coordinate.latitude,
                                           longitude: latestLocation.coordinate.longitude)
            
            // 🔥 Call handleRegionCheck to apply/remove restrictions
            self.handleRegionCheck(for: latestLocation)

        }
    }
}
