//
//  LandmarkList.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct LandmarkList: View {
    var cityName: String
    var country: String
    @State var landmarks: [Landmark] = []
    
    var body: some View {
        NavigationSplitView {
            List(landmarks, id: \.formattedAddress) { landmark in
                NavigationLink {
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }
        } detail: {
            Text("Select a landmark")
        }
        .onAppear {
            Task.init {
                if let places: Places = await WebService().fetchLandmarks(cityName: cityName, country: country) {
                    self.landmarks = places.places
                } else {
                    self.landmarks = []
                }
            }
        }
    }
}

#Preview {
    LandmarkList(cityName: "London", country: "England", landmarks: landmarks.places)
}
