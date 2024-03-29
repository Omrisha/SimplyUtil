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
            AsyncImage(url: URL(string: landmark.images.first!)){  image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            Text(landmark.displayName.text)
            
            Spacer()
        }
    }
}

#Preview {
    Group {
        LandmarkRow(landmark: landmarks.places[0])
        LandmarkRow(landmark: landmarks.places[1])
    }
}
