//
//  StarView.swift
//  simplyutil
//
//  Created by Omri Shapira on 29/03/2024.
//

import SwiftUI

struct StarView: View {
    var rating: Double
    private let totalStars = 5
    
    var body: some View {
        HStack {
            ForEach(0..<totalStars, id: \.self) { index in
                Image(systemName: index < Int(rating) ? "star.fill" : (index < Int(ceil(rating)) ? "star.lefthalf.fill" : "star"))
                    .foregroundColor(index < Int(rating) ? .yellow : .gray)
            }
        }
    }
}

#Preview {
    StarView(rating: 3.5)
}
