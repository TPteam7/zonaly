import SwiftUI
import MapKit

struct LocationPickerView: View {
    @StateObject private var locationManager: LocationManager
    @State private var region: MKCoordinateRegion
    @State private var radius: Double = 200
    @State private var hasCenteredOnUser: Bool = false
    @State private var isExpanded: Bool = false

    // ✅ Custom init to safely set initial region
    init() {
        let manager = LocationManager()
        _locationManager = StateObject(wrappedValue: manager)

        if let userLoc = manager.userLocation {
            _region = State(initialValue: MKCoordinateRegion(
                center: userLoc.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }

    var body: some View {
        let mapWidth = UIScreen.main.bounds.width
        let metersPerPoint = region.metersPerPoint(width: mapWidth)
        let circleDiameter = CGFloat(radius * 2 / metersPerPoint)

        return ZStack {
            // 🗺️ Fullscreen Map
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)

            // 📍 Radius Overlay Circle (only shows when expanded)
            if isExpanded {
                GeometryReader { geometry in
                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [
                                Color.yellow.opacity(0.1),
                                Color.yellow.opacity(0.3),
                                Color.yellow.opacity(0.6)
                            ]), center: .center, startRadius: 0, endRadius: circleDiameter / 2)
                        )
                        .frame(width: circleDiameter, height: circleDiameter)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .allowsHitTesting(false)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.25), value: isExpanded)
                }
            }

            // ➕ Floating Action Button / Expanded Panel
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    if isExpanded {
                        // 🧭 Expanded Controls
                        VStack(spacing: 16) {
                            VStack(spacing: 4) {
                                Text("Radius: \(Int(radius)) meters")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Slider(value: $radius, in: 50...1000, step: 50)
                                    .accentColor(.highlightYellow)
                            }
                            .padding(.horizontal)

                            RoundedButton(title: "Confirm Location", color: .highlightYellow) {
                                let selectedCenter = region.center
                                locationManager.setRegionCenter(latitude: selectedCenter.latitude,
                                                                longitude: selectedCenter.longitude)
                                locationManager.setRegionRadius(radius)
                                print("✅ Region Confirmed: \(selectedCenter.latitude), \(selectedCenter.longitude) at \(radius)m")
                                withAnimation {
                                    isExpanded = false
                                }
                            }
                            .padding(.horizontal)

                            Button {
                                withAnimation {
                                    isExpanded = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red.opacity(0.8))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .background(Color.primaryBlue)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.trailing, 16)
                        .padding(.bottom, 100)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    } else {
                        // ➕ Floating Button
                        Button {
                            withAnimation {
                                isExpanded = true
                            }
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
                        .padding(.bottom, 100)
                        .accessibilityLabel("Add Location")
                    }
                }
            }
        }
        .navigationBarTitle("Set Location", displayMode: .inline)
    }
}


import CoreLocation

extension MKCoordinateRegion {
    /// Approximate number of meters per screen point at current zoom
    func metersPerPoint(width: CGFloat) -> Double {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        let spanLocation = CLLocation(latitude: center.latitude,
                                      longitude: center.longitude + span.longitudeDelta / 2)

        let distance = centerLocation.distance(from: spanLocation)
        return distance / Double(width / 2)
    }
}
