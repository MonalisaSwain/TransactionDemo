//
//  MapUtility.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import Foundation
import CoreLocation

class MapUtility {
    static let shared = MapUtility()
    
    func getCoordinates(forAddress address: String, completion: @escaping (_ location: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
}
