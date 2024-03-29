/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that presents a map.
*/

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(position: .constant(.region(region))) {
            Marker(coordinate: coordinate){
                Text(name)
            }
        }
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

#Preview {
    MapView(name: "Test", coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
}
