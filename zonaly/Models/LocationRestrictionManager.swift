//
//  LocationRestrictionManager.swift
//  zonaly
//
//  Created by Trevor Pope on 4/9/25.
//

import Foundation
import CoreLocation
import FamilyControls
import ManagedSettings
import Combine

class LocationRestrictionManager: ObservableObject {
    static let shared = LocationRestrictionManager()

    private var cancellables = Set<AnyCancellable>()
    @Published var currentRegionID: UUID? = nil

    private let locationManager = CLLocationManager()
    private(set) var locationStore: LocationStore?

    private init() {
        startMonitoring()
    }

    func injectLocationStore(_ store: LocationStore) {
        self.locationStore = store
    }

    private func startMonitoring() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        NotificationCenter.default.publisher(for: .didUpdateUserLocation)
            .sink { [weak self] notification in
                guard let self = self,
                      let location = notification.object as? CLLocation else { return }
                self.handleLocationUpdate(location)
            }
            .store(in: &cancellables)
    }

    private func handleLocationUpdate(_ userLocation: CLLocation) {
        guard let locations = locationStore?.savedLocations else { return }

        for location in locations {
            let center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if userLocation.distance(from: center) <= location.radius {
                if currentRegionID != location.id {
                    currentRegionID = location.id
                    print("🟢 Entered region: \(location.name)")
                    applyRestrictions(from: location)
                }
                return
            }
        }

        if currentRegionID != nil {
            print("🔴 Exited all regions")
            currentRegionID = nil
            FamilyControlsManager.shared.removeRestrictions()
        }
    }

    private func applyRestrictions(from location: SavedLocation) {
        guard let selection = location.activitySelection else {
            print("⚠️ No valid restrictions for this location.")
            return
        }

        FamilyControlsManager.shared.updateSelection(selection)
        FamilyControlsManager.shared.applyRestrictions()
    }
}
