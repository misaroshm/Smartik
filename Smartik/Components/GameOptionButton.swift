//
//  GameOptionButton.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

struct GameOptionButton: View {
    let title: String
    let backgroundColor: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title.uppercased())
                    .font(AppFont.comfortaaBold.font(size: 20))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(backgroundColor)
            .cornerRadius(30)
            .padding(.horizontal, 32)
            .scaleEffect(isSelected ? 1.05 : 1)
        }
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    GameOptionButton(
        title: "Hello",
        backgroundColor: .green,
        isSelected: true) {
        }
}

