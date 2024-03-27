//
//  SwipableCard.swift
//  simplyutil
//
//  Created by Omri Shapira on 23/03/2024.
//

import Foundation
import SwiftUI

struct SwipableCard: View {
    var item: FavoriteEntity
    @State private var offset = CGSize.zero
    var customAction: () -> Void
    var cardView: any View

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Delete button that appears behind the rectangle
                Button(action: {
                    customAction()
                }) {
                    Image(systemName: "trash")
                        .frame(width: 50, height: 150)
                        .background(Color.red)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 150, height: 150, alignment: .trailing)

                CityRow(cityData: item)
                    .offset(x: offset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.offset = gesture.translation
                            }
                            .onEnded { _ in
                                withAnimation {
                                    if offset.width < -50 { // Swiped far enough to reveal delete button
                                        offset = CGSize(width: -65, height: 0)
                                    } else {
                                        offset = .zero
                                    }
                                }
                            }
                    )
            }
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    do {
        let favorite = FavoriteEntity(id: 1, name: "Ramat Gan", threeLetterCode: "ISR", currency: "ILS", country: "Israel", isFavorite: true)
        return SwipableCard(item: favorite, customAction: {
            print("Delete")
        }, cardView: CityRow(cityData: favorite))
    } catch {
        fatalError("Failed to create model container")
    }
}

