//
//  LocationExtensions.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/04/2024.
//

import Foundation
import CoreLocation

func getCoordinate(addressString : String) async -> CLLocation? {
    do {
        let geocoder = CLGeocoder()
        
        let placemark: [CLPlacemark] = try await geocoder.geocodeAddressString(addressString)
        
        let location = placemark[0].location!
        
        return location
    } catch {
        print(error.localizedDescription)
    }
    
    return nil
}
