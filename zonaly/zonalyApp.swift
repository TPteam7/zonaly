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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
