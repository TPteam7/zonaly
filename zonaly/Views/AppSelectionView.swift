import SwiftUI
import FamilyControls

struct AppSelectionView: View {
    @State private var selection = FamilyActivitySelection()
    
    var body: some View {
        VStack {
            FamilyActivityPicker(selection: $selection)
                .onChange(of: selection) { oldSelection, newSelection in
                    FamilyControlsManager.shared.updateSelection(newSelection)
                    saveSelection(newSelection) // Save to persist selection
                }
                .onAppear {
                    loadSelection() // Load saved selection on view load
                }

            Button("Save Selections") {
                FamilyControlsManager.shared.applyRestrictions()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    // Function to save selection
    private func saveSelection(_ selection: FamilyActivitySelection) {
        if let data = try? JSONEncoder().encode(selection) {
            UserDefaults.standard.set(data, forKey: "savedSelection")
        }
    }

    // Function to load selection
    private func loadSelection() {
        if let data = UserDefaults.standard.data(forKey: "savedSelection"),
           let savedSelection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            selection = savedSelection
        }
    }
}
