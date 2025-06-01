//
//  MemoryGsmeViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//
//


import Foundation
import SwiftUI

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [MemoryCard] = []
    @Published var selectedIndices: [Int] = []
    @Published var matchedCount = 0
    @Published var round = 1
    @Published var timeRemaining = 30
    @Published var isTimeOver = false
    @Published var isGameOver: Bool = false
    
    
    private var timer: Timer?
    
    let allContent = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵"]
    
    private let gridSizes: [Int: (rows: Int, columns: Int)] = [
        1: (2, 2), //4
        2: (2, 3),  // 6
        3: (2, 4),  // 8
        4: (3, 4)  // 12
    ]
    
    func startNewRound() {
        let totalCards = calculateCardCount(for: round)
        let evenCardCount = totalCards % 2 == 0 ? totalCards : totalCards - 1
        
        let contents = allContent.shuffled().prefix(evenCardCount / 2)
        let duplicated = (contents + contents).shuffled()
        
        self.cards = duplicated.map { MemoryCard(content: $0) }
        self.timeRemaining = max(10, 30 - round * 2)
        self.timer?.invalidate()
        self.startTimer()
        self.matchedCount = 0
        self.selectedIndices = []
        self.isTimeOver = false
    }
    
    func selectCard(at index: Int) {
        guard !cards[index].isMatched,
              !selectedIndices.contains(index),
              selectedIndices.count < 2 else { return }
        
        cards[index].isFlipped = true
        
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            let first = selectedIndices[0]
            let second = selectedIndices[1]
            
            if cards[first].content == cards[second].content {
                cards[first].isMatched = true
                cards[second].isMatched = true
                matchedCount += 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if !self.cards[first].isMatched {
                    self.cards[first].isFlipped = false
                    self.cards[second].isFlipped = false
                }
                self.selectedIndices.removeAll()
            }
        }
    }
    
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            isGameOver = true
        }
    }
    
    func resetGame() {
        round = 1
        startNewRound()
    }
    
    private func calculateCardCount(for round: Int) -> Int {
        if let size = gridSizes[round] {
            return size.rows * size.columns
        } else {
            return 6
        }
    }
    
    
    func gridColumns() -> [GridItem] {
        let columns = gridSizes[round]?.columns ?? 3
        return Array(repeating: GridItem(.flexible()), count: columns)
    }
}
