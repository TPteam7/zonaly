import SwiftUI
import FamilyControls

struct AppSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State var selection: FamilyActivitySelection
    var clearOnAppear: Bool = false

    init(initialSelection: FamilyActivitySelection? = nil, clearOnAppear: Bool = false) {
        _selection = State(initialValue: initialSelection ?? FamilyActivitySelection())
        self.clearOnAppear = clearOnAppear
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                FamilyActivityPicker(selection: $selection)
                    .onChange(of: selection) { _, newSelection in
                        DispatchQueue.main.async {
                            FamilyControlsManager.shared.updateSelection(newSelection)
                            saveSelection(newSelection)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            if clearOnAppear {
                                selection = FamilyActivitySelection()
                                saveSelection(selection)
                            }
                        }
                    }

                Button("Save Selections & Close") {
                    FamilyControlsManager.shared.applyRestrictions()
                    dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .navigationTitle("Select Apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func saveSelection(_ selection: FamilyActivitySelection) {
        if let data = try? JSONEncoder().encode(selection) {
            UserDefaults.standard.set(data, forKey: "savedSelection")
        }
    }
}
