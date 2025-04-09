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

            // 🔥 Broadcast location update
            NotificationCenter.default.post(name: .didUpdateUserLocation, object: latestLocation)
        }
    }
}

import Foundation

extension Notification.Name {
    static let didUpdateUserLocation = Notification.Name("didUpdateUserLocation")
}
