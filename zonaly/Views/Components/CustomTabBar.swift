import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        let tabCount = CGFloat(Tab.allCases.count)

        ZStack(alignment: .topLeading) {
            // Tab Items Background
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: { selectedTab = tab }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 18)
            .padding(.bottom, 26)

            // Floating Indicator
            GeometryReader { geo in
                let tabWidth = geo.size.width / tabCount

                Capsule()
                    .fill(Color.yellow)
                    .frame(width: 30, height: 5)
                    .offset(
                        x: tabWidth * CGFloat(selectedTab.index) + (tabWidth - 30) / 2,
                        y: -2
                    )
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }
        }
        .frame(height: 85)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
}
