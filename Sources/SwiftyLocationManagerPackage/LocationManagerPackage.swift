//
//  File.swift
//  
//
//  Created by Ishwar Chand Dixit on 18/09/23.
//

import CoreLocation
import Combine

@available(macOS 10.15, *)
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()

    @Published public var isInsideGeofence = false
    @Published public var altitude: CLLocationDistance = 0.0

    public init(latitude: Double, longitude: Double, radius: CLLocationDistance) {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        
        let geofenceRegion = createGeofenceRegion(latitude: latitude, longitude: longitude, radius: radius)
        locationManager.startMonitoring(for: geofenceRegion)
        locationManager.requestLocation()
    }

    private func createGeofenceRegion(latitude: Double, longitude: Double, radius: CLLocationDistance) -> CLCircularRegion {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = CLCircularRegion(center: center, radius: radius, identifier: "CustomGeofence")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        return region
    }

    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        isInsideGeofence = true
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        isInsideGeofence = false
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                altitude = location.altitude
            }
    }
}
