//
//  GridItemView.swift
//  simplyutil
//
//  Created by Omri Shapira on 29/03/2024.
//

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: String


    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: item)!) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
        }
    }
}

#Preview {
    GridItemView(size: 50, item: "https://images.edrawmind.com/article/london-bridge-history/800_531.jpg")
}
