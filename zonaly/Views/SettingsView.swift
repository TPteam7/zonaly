import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Max"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("locationTracking") private var locationTracking: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Custom full-width title
            Text("Settings")
                .font(.largeTitle).bold()
                .padding(.horizontal)
                .padding(.top, 24)
                .padding(.bottom, 8)

            // The actual settings form
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
                        print("Logging out...")
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            .scrollContentBackground(.hidden) // hides gray background
        }
        .background(Color(.systemBackground)) // makes background match
    }
}
