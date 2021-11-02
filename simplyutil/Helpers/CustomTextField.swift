//
//  CustomTextField.swift
//  simplyutil
//
//  Created by Omri Shapira on 01/11/2021.
//

import SwiftUI

struct CustomTextField: View {
    var imageName: String
    var placeholder: String
    @State var text: String = ""
    var rates = ["USD", "ILS", "JPY", "EUR"]
    @State private var selectedRate = "USD"
    
    var body: some View {
        HStack {
            Image(systemName: self.imageName)
                .foregroundColor(Color("PlaceholderColor"))
            TextField(self.placeholder, text: self.$text)
                .foregroundColor(Color("PlaceholderColor"))
            Divider()
                .frame(height: 20)
                .foregroundColor(Color("PlaceholderColor"))
            Picker("Rate", selection: $selectedRate) {
                            ForEach(rates, id: \.self) {
                                Text($0)
                            }
                        }
        }.padding()
        .background(Color("TextColor"))
        .cornerRadius(20)
        .shadow(radius: 10.0, x: 20, y: 10)
        .accentColor(Color("PlaceholderColor"))
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomTextField(imageName: "person", placeholder: "Email")
                .previewLayout(.sizeThatFits)
            
            CustomTextField(imageName: "person", placeholder: "Email")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
