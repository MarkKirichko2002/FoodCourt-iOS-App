//
//  LocationManager.swift
//  FoodCourt
//
//  Created by Марк Киричко on 01.12.2024.
//

import CoreLocation

final class LocationManager {
    
    func getAddress(latitude: Double, longtitude: Double, completion: @escaping(String?, Error?)->Void) {
        let location = CLLocation(latitude: latitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(nil, error)
                return
            }
            
            completion("\(placemark.thoroughfare ?? "Нет улицы"), \(placemark.subThoroughfare ?? "Нет номера дома")", nil)
        }
    }
}
