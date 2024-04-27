//
//  CustomSlider.swift
//  simplyutil
//
//  Created by Omri Shapira on 25/03/2024.
//

import SwiftUI

struct SliderView: View {
    var currentTemperature: CGFloat
    var minTemperature: CGFloat
    var maxTemperature: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 10)
                .foregroundColor(.gray.opacity(0.3))
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: widthForTemperature(current: currentTemperature, in: 150), height: 10)
                .foregroundColor(.orange)
                
            Circle() // The slider "thumb"
                .frame(width: 10, height: 10)
                .foregroundColor(.white)
                .shadow(radius: 3)
                .offset(x: offsetForTemperature(current: currentTemperature, in: 150) - 5)
        }
        .frame(height: 10)
    }
    
    // Calculate width based on current temperature
    private func widthForTemperature(current: CGFloat, in totalWidth: CGFloat) -> CGFloat {
        let range = maxTemperature - minTemperature
        let normalizedTemp = current - minTemperature
        return (normalizedTemp / range) * totalWidth
    }
    
    // Calculate the offset for the slider "thumb"
    private func offsetForTemperature(current: CGFloat, in totalWidth: CGFloat) -> CGFloat {
        let range = maxTemperature - minTemperature
        let normalizedTemp = current - minTemperature
        return (normalizedTemp / range) * totalWidth
    }
}

#Preview {
    SliderView(currentTemperature: 20, minTemperature: 15, maxTemperature: 40)
}
