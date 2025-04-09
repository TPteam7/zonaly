//
//  Extensions.swift
//  zonaly
//
//  Created by Trevor Pope on 4/4/25.
//

import CoreLocation
import SwiftUI

extension View {
    var safeAreaInsetBottom: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.safeAreaInsets.bottom ?? 0
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension CLLocationCoordinate2D {
    func metersPerPoint(screenWidth: CGFloat) -> Double {
        // Small longitude delta to simulate zoom level and compute horizontal distance
        let spanOffset: CLLocationDegrees = 0.005
        let centerLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let spanLocation = CLLocation(latitude: self.latitude, longitude: self.longitude + spanOffset)
        let distance = centerLocation.distance(from: spanLocation)
        return distance / (screenWidth / 2)
    }
}
