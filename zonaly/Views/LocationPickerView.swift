import SwiftUI
import MapKit

struct LocationPickerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var radius: Double = 50
    @State private var showDetailModal = false
    @EnvironmentObject var locationStore: LocationStore

    var body: some View {
        ZStack {
            Map(position: $cameraPosition, interactionModes: .all) {
                UserAnnotation()
            }
            .onAppear {
                if let userLocation = locationManager.userLocation?.coordinate {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: userLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let newLocation = newLocation {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: newLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showDetailModal = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.highlightYellow)
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 30)
                    .accessibilityLabel("Add Zone")
                    .fullScreenCover(isPresented: $showDetailModal) {
                        // For a new zone, pass nil for editLocation so defaults are used.
                        LocationDetailView(
                            editLocation: nil,
                            clearSelectionsOnOpen: true  // Clears selections for new zone creation
                        ) { newLocation in
                            locationStore.savedLocations.append(newLocation)
                            // Print saved locations for debugging:
                            for location in locationStore.savedLocations {
                                print("""
                                📍 Saved Location:
                                Name: \(location.name)
                                Coordinates: (\(location.coordinate.latitude), \(location.coordinate.longitude))
                                Radius: \(location.radius)
                                Activity Selection: \(String(describing: location.activitySelection))
                                """)
                            }
                        }
                    }
                }
            }
        }
    }
}
