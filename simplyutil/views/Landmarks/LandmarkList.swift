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
    
    @State private var cachedLandmarks: [Landmark]?
    @State private var isLoadingLandmarks = false
    @State private var selectedLandmark: Landmark?
    
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
                        Button {
                            selectedLandmark = landmark
                        } label: {
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
        .sheet(item: $selectedLandmark) { landmark in
            NavigationStack {
                LandmarkDetail(landmark: landmark)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                selectedLandmark = nil
                            }
                        }
                    }
            }
        }
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
    return LandmarkList(
        cityName: "London",
        country: "England"
    )
}
