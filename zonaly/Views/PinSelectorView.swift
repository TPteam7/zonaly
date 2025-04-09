import SwiftUI
import MapKit
import CoreLocation

struct PinSelectorView: View {
    let initialRegion: MKCoordinateRegion
    @Binding var radius: Double
    var onConfirm: ((MKCoordinateRegion, CLLocationCoordinate2D, Double) -> Void)

    @Environment(\.dismiss) private var dismiss
    @StateObject private var locationManager = LocationManager()

    @State private var cameraPosition: MapCameraPosition
    @State private var centerCoordinate: CLLocationCoordinate2D
    @State private var currentRegionSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    @State private var sliderValue: Double = 0.2
    @State private var hasRecentered = false

    init(initialRegion: MKCoordinateRegion, radius: Binding<Double>, onConfirm: @escaping (MKCoordinateRegion, CLLocationCoordinate2D, Double) -> Void) {
        self.initialRegion = initialRegion
        self._radius = radius
        self.onConfirm = onConfirm

        _cameraPosition = State(initialValue: .region(initialRegion))
        _centerCoordinate = State(initialValue: initialRegion.center)
    }

    var computedRadius: Double {
        let minRadius: Double = 20
        let maxRadius: Double = 1000
        let curved = pow(sliderValue, 2)
        return minRadius + curved * (maxRadius - minRadius)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)

                ZStack {
                    Map(position: $cameraPosition, interactionModes: .all) {
                        UserAnnotation()
                    }
                    .onMapCameraChange(frequency: .continuous) { context in
                        centerCoordinate = context.region.center
                        currentRegionSpan = context.region.span
                    }

                    GeometryReader { geo in
                        let mapWidth = geo.size.width
                        let metersPerPoint = metersPerPointAtLatitude(
                            latitude: centerCoordinate.latitude,
                            latitudeDelta: currentRegionSpan.latitudeDelta,
                            viewWidth: mapWidth
                        )
                        let diameterInPoints = CGFloat((radius * 2) / metersPerPoint)

                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .background(Circle().fill(Color.blue.opacity(0.2)))
                            .frame(width: diameterInPoints, height: diameterInPoints)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    }
                    .allowsHitTesting(false)
                }
                .frame(height: 320)
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 4) {
                    Text("RADIUS: \(Int(radius)) meters")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Slider(value: $sliderValue, in: 0...1)
                        .accentColor(.highlightYellow)
                        .padding(.horizontal)
                        .onChange(of: sliderValue) { _ in
                            radius = computedRadius
                        }
                }

                Spacer()

                Button(action: {
                    let region = MKCoordinateRegion(
                        center: centerCoordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    onConfirm(region, centerCoordinate, radius)
                    dismiss()
                }) {
                    Text("CONFIRM LOCATION")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.highlightYellow)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Pin Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: locationManager.userLocation) { newLocation in
                if let coordinate = newLocation?.coordinate, !hasRecentered {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
                    ))
                    centerCoordinate = coordinate
                    hasRecentered = true
                }
            }
            .onAppear {
                if radius < 20 {
                    radius = 50
                }
                let minRadius: Double = 20
                let maxRadius: Double = 1000
                let normalized = (radius - minRadius) / (maxRadius - minRadius)
                sliderValue = sqrt(normalized)
            }
        }
    }

    func metersPerPointAtLatitude(latitude: CLLocationDegrees, latitudeDelta: CLLocationDegrees, viewWidth: CGFloat) -> Double {
        let earthCircumference: Double = 40_075_000 // in meters
        let degreesPerScreen = latitudeDelta
        let metersPerDegree = earthCircumference / 360.0
        let mapWidthInMeters = metersPerDegree * degreesPerScreen
        return mapWidthInMeters / Double(viewWidth)
    }
}
