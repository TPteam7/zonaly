import SwiftUI
import MapKit
import FamilyControls

struct LocationDetailView: View {
    // Pre-populated values from edit (if available)
    let initialCoordinate: CLLocationCoordinate2D
    let initialRadius: Double
    let editLocation: SavedLocation?

    // Save closure
    var onSave: ((SavedLocation) -> Void)? = nil

    @FocusState private var nameFieldIsFocused: Bool

    @State private var locationName: String = ""
    @State private var selectedAppsCount = 0
    @State private var selectedCategoriesCount = 0
    @State private var showPinSelector = false
    @State private var showAppSelector = false
    @State private var hasConfirmedLocation = false

    @State private var coordinate: CLLocationCoordinate2D
    @State private var radius: Double

    @Environment(\.dismiss) private var dismiss

    let clearSelectionsOnOpen: Bool

    /// New initializer: if editLocation is non-nil, prepopulate the fields.
    init(
        editLocation: SavedLocation? = nil,
        clearSelectionsOnOpen: Bool = false,
        onSave: ((SavedLocation) -> Void)? = nil
    ) {
        self.clearSelectionsOnOpen = clearSelectionsOnOpen
        self.onSave = onSave
        self.editLocation = editLocation

        if let location = editLocation {
            self.initialCoordinate = location.coordinate
            self.initialRadius = location.radius
            _locationName = State(initialValue: location.name)
        } else {
            self.initialCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            self.initialRadius = 50
            _locationName = State(initialValue: "")
        }

        _coordinate = State(initialValue: self.initialCoordinate)
        _radius = State(initialValue: self.initialRadius)
    }

    var isFormValid: Bool {
        !locationName.trimmingCharacters(in: .whitespaces).isEmpty && hasConfirmedLocation
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 5)
                
                // Name input
                VStack(alignment: .leading, spacing: 6) {
                    Text("NAME")
                        .font(.caption)
                        .foregroundColor(.gray)
                    TextField("Enter location name", text: $locationName)
                        .focused($nameFieldIsFocused)
                        .padding(.vertical, 14)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                        .contentShape(Rectangle())
                }
                .padding(.horizontal)
                
                // App Selection
                VStack(alignment: .leading, spacing: 6) {
                    Text("SELECT APPS")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Button(action: {
                        showAppSelector = true
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(selectedAppsCount) Apps Selected")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text("\(selectedCategoriesCount) Categories Selected")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 4) {
                                Text("Edit")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray5))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                
                // Pin Selector button
                Button {
                    showPinSelector = true
                } label: {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Choose Location & Radius")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryBlue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showPinSelector) {
                    PinSelectorView(
                        initialRegion: MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ),
                        radius: $radius
                    ) { _, center, selectedRadius in
                        coordinate = center
                        radius = selectedRadius
                        hasConfirmedLocation = true
                    }
                }
                
                Spacer()
                
                // DONE button
                Button(action: {
                    let savedSelection = try? JSONDecoder().decode(
                        FamilyActivitySelection.self,
                        from: UserDefaults.standard.data(forKey: "savedSelection") ?? Data()
                    )
                    let newLocation = SavedLocation(
                        name: locationName,
                        coordinate: coordinate,
                        radius: radius,
                        activitySelection: savedSelection
                    )
                    
                    #if DEBUG
                    print("📍 Location saved: \(newLocation)")
                    #endif
                    
                    UIApplication.shared.hideKeyboard()
                    onSave?(newLocation)
                    dismiss()
                }) {
                    Text("DONE")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.highlightYellow : Color.gray.opacity(0.5))
                        .cornerRadius(12)
                }
                .padding()
                .disabled(!isFormValid)
            }
            .background(Color(.systemBackground))
            .fullScreenCover(isPresented: $showAppSelector, onDismiss: updateSelectionCounts) {
                AppSelectionView(
                    initialSelection: editLocation?.activitySelection,
                    clearOnAppear: clearSelectionsOnOpen
                )
            }
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
            .onAppear {
                if clearSelectionsOnOpen {
                    // For a new location, clear any previously saved app selection.
                    let emptySelection = FamilyActivitySelection()
                    if let data = try? JSONEncoder().encode(emptySelection) {
                        UserDefaults.standard.set(data, forKey: "savedSelection")
                    }
                    selectedAppsCount = 0
                    selectedCategoriesCount = 0
                } else {
                    updateSelectionCounts()
                }
            }
            .navigationTitle("Add Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private func updateSelectionCounts() {
        guard let data = UserDefaults.standard.data(forKey: "savedSelection"),
              let selection = try? JSONDecoder().decode(
                FamilyActivitySelection.self,
                from: data
              ) else {
            selectedAppsCount = 0
            selectedCategoriesCount = 0
            return
        }
        selectedAppsCount = selection.applicationTokens.count
        selectedCategoriesCount = selection.categoryTokens.count
    }
}
