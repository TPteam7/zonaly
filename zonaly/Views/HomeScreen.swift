import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Tab
    @State private var userName = "Max"
    @State private var locations = ["My House", "Library"]
    @State private var navigateToLocationPicker = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hello \(userName)!")
                            .font(.headlineLarge)
                            .foregroundColor(.white)
                        Text("Take control of your spaces.")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image("profile") // Add a profile image to assets
                        .resizable()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
                .padding(.horizontal)

                // Buttons
                HStack(spacing: 15) {
                    RoundedButton(title: "New Location", color: Color.yellow) {
                        selectedTab = .map
                    }

                    RoundedButton(title: "Groups", color: Color.orange) {
                        print("Groups tapped")
                        // Future: Navigate to groups
                    }
                }
                .padding(.horizontal)

                Text("My Locations")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(locations, id: \.self) { location in
                            LocationCard(name: location)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
            .background(Color.darkBlue.ignoresSafeArea())
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: LocationPickerView(), isActive: $navigateToLocationPicker) {
                    EmptyView()
                }
                .hidden()
            )
        }
        .tabViewStyle(PageTabViewStyle())
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
    }
}
