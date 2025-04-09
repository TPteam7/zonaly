import Foundation
import CoreLocation

class LocationStore: ObservableObject {
    @Published var savedLocations: [SavedLocation] = [] {
        didSet {
            saveToDisk()
        }
    }

    private let saveKey = "savedLocations"
    private weak var restrictionManager: LocationRestrictionManager?

    // 🔧 Custom init accepting a restriction manager
    init(restrictionManager: LocationRestrictionManager? = nil) {
        self.restrictionManager = restrictionManager
        loadFromDisk()
    }

    private func saveToDisk() {
        if let data = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadFromDisk() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([SavedLocation].self, from: data) {
            savedLocations = decoded
        }
    }

    func delete(_ location: SavedLocation) {
        print("🧩 Attempting to delete location with name: \(location.name)")
        print("🧩 Current active region id: \(String(describing: restrictionManager?.currentRegionID))")

        // Find the currently active region (if any)
        if let activeID = restrictionManager?.currentRegionID,
           let activeLocation = savedLocations.first(where: { $0.id == activeID }) {
            
            if activeLocation.name == location.name {
                print("🗑️ Deleted active region (by name match): removing restrictions")
                restrictionManager?.currentRegionID = nil
                FamilyControlsManager.shared.removeRestrictions()
            } else {
                print("❌ Region mismatch – names differ")
            }
        }

        print("Deleting location from savedLocations")
        savedLocations.removeAll { $0.id == location.id }
    }

}
