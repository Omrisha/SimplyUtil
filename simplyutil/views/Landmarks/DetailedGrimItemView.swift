//
//  DetailedGrimItemView.swift
//  simplyutil
//
//  Created by Omri Shapira on 30/03/2024.
//

import SwiftUI

struct DetailedGrimItemView: View {
    let item: String

    var body: some View {
        AsyncImage(url: URL(string: item)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    DetailedGrimItemView(item: "https://images.edrawmind.com/article/london-bridge-history/800_531.jpg")
}
