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
                
                CircleImage(imageUrl: URL(string: landmark.images.first!)!)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                VStack(alignment: .leading) {
                    Text(landmark.displayName.text)
                        .font(.title)
                    
                    HStack {
                        Text(landmark.formattedAddress)
                        Spacer()
                        StarView(rating: landmark.rating)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text("About \(landmark.displayName.text)")
                        .font(.title2)
                    LandmarkPhotoGallery(photosUrls: landmark.images)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle(landmark.displayName.text)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LandmarkDetail(landmark: landmarks.places[0])
}
