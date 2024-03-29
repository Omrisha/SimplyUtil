/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import SwiftUI

struct CircleImage: View {
    var imageUrl: URL
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
        } placeholder: {
            ProgressView()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
        }
            
    }
}

#Preview {
    CircleImage(imageUrl: URL(string: "https://images.edrawmind.com/article/london-bridge-history/800_531.jpg")!)
}
