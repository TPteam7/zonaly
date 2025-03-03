import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            VStack {
                Text("User Location")
                    .font(.title)
                    .padding()

                if let location = locationManager.userLocation {
                    Text("Latitude: \(location.coordinate.latitude)")
                    Text("Longitude: \(location.coordinate.longitude)")
                    
                    Button(action: {
                        locationManager.setRegionCenter(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    }) {
                        Text("📍 Set Region Center Here")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    VStack {
                        Text("Region Radius: \(Int(locationManager.regionRadius)) meters")
                        Slider(value: $locationManager.regionRadius, in: 10...500, step: 10)
                            .padding()
                    }

                    if let center = locationManager.regionCenter {
                        let isInside = locationManager.isInsideRegion(userLocation: location)

                        if isInside {
                            Text("✅ You are inside the region!")
                                .foregroundColor(.green)
                        } else {
                            Text("❌ You are outside the region.")
                                .foregroundColor(.red)
                        }
                    } else {
                        Text("Region center not set")
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("Fetching location...")
                        .foregroundColor(.gray)
                }

                NavigationLink(destination: AppSelectionView()) {
                    Text("Select Apps to Block")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Location Tracker")
        }
    }
}
