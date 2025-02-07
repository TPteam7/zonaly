import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var locationChecker = LocationChecker()
    
    @State private var accuracyThreshold: Double = 10 // User-defined accuracy filter

    var body: some View {
        VStack {
            Text("User Location")
                .font(.title)
                .padding()

            if let location = locationManager.userLocation {
                Text("Latitude: \(location.coordinate.latitude)")
                    .padding()
                Text("Longitude: \(location.coordinate.longitude)")
                    .padding()
                
                Text("GPS Accuracy: ±\(String(format: "%.2f", location.horizontalAccuracy)) meters")
                    .foregroundColor(location.horizontalAccuracy < accuracyThreshold ? .green : .red)
                    .padding()

                // Set Current Location as Region Center
                Button(action: {
                    locationChecker.setRegionCenter(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }) {
                    Text("📍 Set Region Center Here")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // Radius Adjustment Slider
                VStack {
                    Text("Region Radius: \(Int(locationChecker.regionRadius)) meters")
                    Slider(value: $locationChecker.regionRadius, in: 10...500, step: 10)
                        .padding()
                }

                // Accuracy Threshold Slider
                VStack {
                    Text("GPS Accuracy Filter: \(Int(accuracyThreshold)) meters")
                    Slider(value: $accuracyThreshold, in: 3...50, step: 1)
                        .padding()
                }

                // Check if inside the region
                if let center = locationChecker.regionCenter {
                    let isInside = locationChecker.isInsideRegion(userLocation: location)
                    let distanceText = locationChecker.formattedDistanceFromRegion(userLocation: location)

                    if isInside {
                        Text("✅ You are inside the region!")
                            .foregroundColor(.green)
                            .padding()
                    } else {
                        Text("❌ You are outside the region.")
                            .foregroundColor(.red)
                            .padding()
                        Text("Distance from region: \(distanceText)")
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    Text("Region center not set")
                        .foregroundColor(.gray)
                        .padding()
                }
            } else {
                Text("Fetching location...")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding()
    }
}
