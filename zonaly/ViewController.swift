//
//  ViewController.swift
//  zonaly
//
//  Created by Trevor Pope on 2/6/25.
//

import UIKit
// 1
import CoreLocation

class ViewController: UIViewController {

    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        

        // 3
        locationManager?.requestWhenInUseAuthorization()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        // 1
        case .authorizedAlways:
            print("When user select option Change to Always Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
            // 2
            locationManager?.requestAlwaysAuthorization()
        default:
            print("default")
        }
    }
}
