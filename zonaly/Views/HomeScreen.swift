import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Tab
    @State private var userName = "Trevor"
    @EnvironmentObject var locationStore: LocationStore
    @State private var navigateToDetail = false
    @State private var selectedLocation: SavedLocation?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Hello \(userName)!")
                        .font(.headlineLarge)
                        .foregroundColor(.white)
                    Text("Take control of your spaces.")
                        .foregroundColor(.white)
                }
                Spacer()
                Image("profile")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            
            // Buttons
            HStack(spacing: 15) {
                RoundedButton(title: "New Zone", color: Color.yellow) {
                    selectedTab = .map
                }
                RoundedButton(title: "Groups", color: Color.orange) {
                    print("Groups tapped")
                }
            }
            .padding(.horizontal)
            
            Text("My Locations")
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // List of Locations
            ScrollView {
                VStack(spacing: 10) {
                    if locationStore.savedLocations.isEmpty {
                        VStack(spacing: 20) {
                            Image("empty-zones")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding(.top, 50)
                            Text("No locations yet!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text("Tap 'New Zone' to add a location for content blocking.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ForEach(locationStore.savedLocations) { location in
                            LocationCard(
                                name: location.name,
                                onDelete: {
                                    locationStore.delete(location)
                                },
                                onEdit: {
                                    selectedLocation = location
                                    navigateToDetail = true
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .background(Color.darkBlue.ignoresSafeArea())
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $navigateToDetail) {
            // Force unwrap selectedLocation (safe because onEdit always sets it)
            LocationDetailView(
                editLocation: selectedLocation,
                clearSelectionsOnOpen: false, // Editing an existing location: do not clear selections
                onSave: { updatedLocation in
                    if let index = locationStore.savedLocations.firstIndex(where: { $0.id == selectedLocation!.id }) {
                        locationStore.savedLocations[index] = updatedLocation
                    }
                }
            )
        }
    }
}
