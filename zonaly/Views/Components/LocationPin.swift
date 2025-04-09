//
//  LocationPin.swift
//  zonaly
//
//  Created by Trevor Pope on 4/2/25.
//

import Foundation
import CoreLocation

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
