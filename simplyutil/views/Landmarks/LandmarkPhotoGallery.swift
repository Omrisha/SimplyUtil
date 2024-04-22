//
//  LandmarkPhotoGallery.swift
//  simplyutil
//
//  Created by Omri Shapira on 29/03/2024.
//

import SwiftUI

struct LandmarkPhotoGallery: View {
    @State var photosUrls: [String]
    private static let initialColumns = 3

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State private var numColumns = initialColumns
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(photosUrls, id: \.self) { item in
                        GeometryReader { geo in
                            GridItemView(size: geo.size.width, item: item)
                                .contextMenu {
                                    Text("Image")
                                } preview: {
                                    DetailedGrimItemView(item: item)
                                }
                        }
                        .cornerRadius(8.0)
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LandmarkPhotoGallery(photosUrls: landmarks.places.first!.images)
}
