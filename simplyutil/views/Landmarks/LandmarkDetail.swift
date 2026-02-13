//
//  LandmarkDetail.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct LandmarkDetail: View {
    var landmark: Landmark
    
    var body: some View {
        ScrollView {
            VStack {
                MapView(name: landmark.displayName.text, coordinate: landmark.locationCoordinates)
                    .frame(height: 300)
                
                // Handle case where there are no images
                if let firstImageString = landmark.images.first,
                   let imageURL = URL(string: firstImageString) {
                    CircleImage(imageUrl: imageURL)
                        .offset(y: -130)
                        .padding(.bottom, -130)
                } else {
                    // Placeholder image when no photo is available
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                        VStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("No Photo")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .offset(y: -130)
                    .padding(.bottom, -130)
                }
                
                VStack(alignment: .leading) {
                    Text(landmark.displayName.text)
                        .font(.title)
                    
                    HStack {
                        Text(landmark.formattedAddress)
                        Spacer()
                        if landmark.rating > 0 {
                            StarView(rating: landmark.rating)
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text("About \(landmark.displayName.text)")
                        .font(.title2)
                    
                    // Only show photo gallery if there are images
                    if !landmark.images.isEmpty {
                        LandmarkPhotoGallery(photosUrls: landmark.images)
                    } else {
                        Text("No photos available for this location.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LandmarkDetail(landmark: landmarks.places[0])
}
