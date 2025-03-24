import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 24) { // ✅ Smaller spacing between tab buttons
            ForEach(Tab.allCases, id: \.self) { tab in
                TabItem(tab: tab, isSelected: selectedTab == tab) {
                    selectedTab = tab
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 24) // ✅ Increased padding above icons
        .padding(.bottom, 28)
        .background(
            Color.mediumBlue
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
        )
        .shadow(color: .black.opacity(0.2), radius: 5, y: -2)
    }
}
