//
//  TabItem.swift
//  zonaly
//
//  Created by Trevor Pope on 3/22/25.
//

import SwiftUI

struct TabItem: View {
    var tab: Tab
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.rawValue)
                    .font(.system(size: 20, weight: .semibold))
                Text(tabLabel(tab))
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .yellow : .white.opacity(0.7))
            .padding(.horizontal)
        }
    }

    private func tabLabel(_ tab: Tab) -> String {
        switch tab {
        case .home: return "Home"
        case .map: return "Map"
        case .settings: return "Settings"
        }
    }
}
