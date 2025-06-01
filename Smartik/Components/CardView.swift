//
//  CardView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 01.06.2025.
//

import SwiftUI

struct CardView: View {
    let imageName: String
    let isSelected: Bool
    var isMatched: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: isSelected ? 6 : 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
                )
                .frame(height: 150)
                .animation(.easeInOut, value: isSelected)
                .opacity(isMatched ? 0.6 : 1.0) 
                .shadow(radius: isSelected ? 5 : 2)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(12)
        }
    }
}


#Preview {
    CardView(imageName: "jellyfish", isSelected: true)
}
