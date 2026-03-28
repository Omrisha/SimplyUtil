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
    @Binding var cachedLandmarks: [Landmark]?
    @Binding var isLoadingLandmarks: Bool
    
    var body: some View {
        List {
            if isLoadingLandmarks {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if let landmarks = cachedLandmarks {
                if landmarks.isEmpty {
                    Text("No landmarks found")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(Array(landmarks.enumerated()), id: \.offset) { index, landmark in
                        NavigationLink(value: landmark) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
            } else {
                Text("No landmarks loaded")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Landmarks")
        .task {
            // Only fetch if we don't have cached data
            if cachedLandmarks == nil {
                await fetchLandmarks()
            }
        }
    }
    
    private func fetchLandmarks() async {
        isLoadingLandmarks = true
        
        if let places = await WebService().fetchLandmarks(cityName: cityName, country: country) {
            cachedLandmarks = places.places
            isLoadingLandmarks = false
            print("✅ Cached \(places.places.count) landmarks for \(cityName)")
        } else {
            cachedLandmarks = []
            isLoadingLandmarks = false
        }
    }
}

#Preview {
    @Previewable @State var landmarks: [Landmark]? = nil
    @Previewable @State var isLoading = false
    
    return LandmarkList(
        cityName: "London",
        country: "England",
        cachedLandmarks: $landmarks,
        isLoadingLandmarks: $isLoading
    )
}
