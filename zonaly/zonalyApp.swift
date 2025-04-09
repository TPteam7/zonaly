//
//  zonalyApp.swift
//  zonaly
//
//  Created by Trevor Pope on 1/28/25.
//

import SwiftUI

@main
struct zonalyApp: App {
    let persistenceController = PersistenceController.shared

    private let restrictionManager = LocationRestrictionManager.shared

    // Create locationStore, injecting the manager into it
    @StateObject private var locationStore: LocationStore

    init() {
        let store = LocationStore(restrictionManager: LocationRestrictionManager.shared)
        restrictionManager.injectLocationStore(store)
        _locationStore = StateObject(wrappedValue: store)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(locationStore)
        }
    }
}
