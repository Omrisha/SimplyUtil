//
//  LandmarkRow.swift
//  simplyutil
//
//  Created by Omri Shapira on 28/03/2024.
//

import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    var body: some View {
        HStack {
            // Handle case where there are no images
            if let firstImage = landmark.images.first, let imageURL = URL(string: firstImage) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    ProgressView()
                }
            } else {
                // Placeholder when no image is available
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(landmark.displayName.text)
                    .font(.headline)
                
                if landmark.rating > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", landmark.rating))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    Group {
        LandmarkRow(landmark: landmarks.places[0])
        LandmarkRow(landmark: landmarks.places[1])
    }
}
