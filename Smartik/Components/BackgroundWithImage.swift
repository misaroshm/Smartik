//
//  BackgroundWithImage.swift
//  Smartik
//
//  Created by Mariia Misarosh on 28.05.2025.
//


import SwiftUI

struct BackgroundWithImage<Content: View>: View {
    let content: () -> Content
    let color: Color
    let image: Image
    
    init(with color: Color = .mainBackground, image: Image = Image(.home), @ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
        self.color = color
        self.image = image
    }
    
    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
            
            image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            
            content()
        }
    }
}


#Preview {
    BackgroundWithImage {
        Text("123")
    }
}
