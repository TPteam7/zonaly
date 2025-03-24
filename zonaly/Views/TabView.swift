import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if selectedTab == .home {
                    HomeView(selectedTab: $selectedTab)
                        .transition(.opacity)
                }
                if selectedTab == .map {
                    LocationPickerView()
                        .transition(.opacity)
                }
                if selectedTab == .settings {
                    SettingsView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()

            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}


enum Tab: String, CaseIterable {
    case home = "house.fill"
    case map = "globe"
    case settings = "gearshape.fill"
}
