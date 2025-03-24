//
//  Theme.swift
//  zonaly
//
//  Created by Trevor Pope on 3/21/25.
//

import SwiftUI

extension Color {
    static let lightBlue = Color(hex: "#0E5BA2")
    static let mediumBlue = Color(hex: "#003566")
    static let darkBlue = Color(hex: "#001D3D")
    static let dark = Color(hex: "#000814")
    
    static let orange = Color(hex: "#FFC300")
    static let yellow = Color(hex: "#FFD60A")
    
    static let whiteCustom = Color(hex: "#FFFFFF")
    static let blackCustom = Color(hex: "#000000")
    
    // App theme roles (set based on design system)
    static let primaryBlue = Color.mediumBlue
    static let highlightYellow = Color.yellow
    static let cardBackground = Color.darkBlue
    static let background = Color.dark
}

// MARK: - Hex color initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0) // fallback: bright yellow
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

extension Font {
    static let headlineLarge = Font.system(size: 22, weight: .bold)
    static let subheadline = Font.system(size: 16, weight: .medium)
}
