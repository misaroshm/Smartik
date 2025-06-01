//
//  MemoryCardView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import SwiftUI

struct MemoryCardView: View {
    let card: MemoryCard
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if card.isFlipped || card.isMatched {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 4)
                    .overlay(
                        Text(card.content)
                            .font(.system(size: 40))
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.mint)
                    .shadow(radius: 4)
            }
        }
        .frame(width: 70, height: 70)
        .onTapGesture {
            action()
        }
        .rotation3DEffect(
            Angle(degrees: card.isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.easeInOut(duration: 0.1), value: card.isFlipped)
    }
}
