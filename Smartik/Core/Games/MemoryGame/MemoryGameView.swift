//
//  MemoryGameView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject var viewModel = MemoryGameViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                TimerAndHeaderView(viewModel: viewModel)
                
                Spacer()
                
                Text("Раунд \(viewModel.round)")
                    .font(AppFont.comicSansMsBold.font(size: 36))
                
                let columns = viewModel.gridColumns()
                let cardWidth = (geo.size.width - CGFloat(columns.count - 1) * 12 - 32) / CGFloat(columns.count)
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.cards.indices, id: \.self) { index in
                        let card = viewModel.cards[index]
                        MemoryCardView(card: card) {
                            viewModel.selectCard(at: index)
                        }
                        .frame(width: cardWidth, height: cardWidth)
                    }
                }
                .padding()
                
                if viewModel.matchedCount == viewModel.cards.count / 2 {
                    Button(action: {
                        viewModel.round += 1
                        viewModel.startNewRound()
                    }) {
                        Text("Наступний раунд")
                            .font(AppFont.comfortaaBold.font(size: 20))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "EF3349"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.startNewRound()
            }
            .fullScreenCover(isPresented: $viewModel.isGameOver) {
                ResultView(
                    correctAnswers: viewModel.matchedCount,
                    totalQuestions: viewModel.cards.count / 2,
                    gameName: .memoryGame,
                    onRestart: {
                        viewModel.resetGame()
                    },
                    selectedTab: $selectedTab
                )
            }
            
        }
    }
}


#Preview {
    MemoryGameView(selectedTab: .constant(.home))
}
