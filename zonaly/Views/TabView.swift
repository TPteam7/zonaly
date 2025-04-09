import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView(selectedTab: $selectedTab)
                        .transition(.opacity)
                case .map:
                    LocationPickerView()
                        .transition(.opacity)
                case .settings:
                    SettingsView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, safeAreaInsetBottom)
                .background(Color.mediumBlue)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case map = "globe"
    case settings = "gearshape.fill"

    var index: Int {
        switch self {
        case .home: return 0
        case .map: return 1
        case .settings: return 2
        }
    }
}
