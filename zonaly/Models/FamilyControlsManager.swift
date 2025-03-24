import Foundation
import FamilyControls
import ManagedSettings

class FamilyControlsManager: ObservableObject {
    static let shared = FamilyControlsManager()
    
    @Published var selectedApps: FamilyActivitySelection = FamilyActivitySelection(includeEntireCategory: true)
    
    private let store = ManagedSettingsStore()
    
    init() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("✅ Authorization granted")
            } catch {
                print("❌ Authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// **Apply App & Category Restrictions**
    func applyRestrictions() {
        store.shield.applications = selectedApps.applicationTokens

        let categorySet = Set<ActivityCategoryToken>(selectedApps.categoryTokens)
        store.shield.applicationCategories = .specific(categorySet, except: []) // Explicit cast
    }

    
    /// **Remove All Restrictions**
    func removeRestrictions() {
        store.shield.applications = [] // Unblock all apps
        store.shield.applicationCategories = .none // Unblock all categories
    }
    
    /// **Update Selection**
    func updateSelection(_ newSelection: FamilyActivitySelection) {
        selectedApps = newSelection
    }
}
