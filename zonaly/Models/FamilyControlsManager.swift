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
        print("🔹 Applying Restrictions...")

        store.shield.applications = selectedApps.applicationTokens
        print("✅ Apps Blocked: \(selectedApps.applicationTokens)")

        // Debugging: Print category tokens before applying restrictions
        print("🔹 Category Tokens: \(selectedApps.categoryTokens)")

        if !selectedApps.categoryTokens.isEmpty {
            let categorySet = Set<ActivityCategoryToken>(selectedApps.categoryTokens)
            store.shield.applicationCategories = .specific(categorySet) // Explicit cast
            print("✅ Applied Category Restrictions: \(categorySet)")
        } else {
            store.shield.applicationCategories = .all()
            print("⚠️ No Category Selected: Allowing all")
        }
    }

    
    /// **Remove All Restrictions**
    func removeRestrictions() {
        store.shield.applications = [] // Unblock all apps
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none // Unblock all categories

        print("✅ Unblocked all apps and categories")
    }
    
    /// **Update Selection**
    func updateSelection(_ newSelection: FamilyActivitySelection) {
        selectedApps = newSelection
    }
}
