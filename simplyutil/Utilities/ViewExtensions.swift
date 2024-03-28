//
//  File.swift
//  simplyutil
//
//  Created by Omri Shapira on 27/03/2024.
//

import SwiftUI

extension View {
    func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}
