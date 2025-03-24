//
//  SettingsView.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Max"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("locationTracking") private var locationTracking: Bool = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    TextField("Name", text: $userName)
                        .textInputAutocapitalization(.words)
                }

                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Allow Location Tracking", isOn: $locationTracking)
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    Link("Privacy Policy", destination: URL(string: "https://your-privacy-policy.com")!)
                }

                Section {
                    Button(role: .destructive) {
                        // Handle logout or reset
                        print("Logging out...")
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
