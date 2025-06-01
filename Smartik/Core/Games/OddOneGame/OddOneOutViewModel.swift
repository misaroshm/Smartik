//
//  OddOneOutViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import Foundation
import SwiftUI

class OddOneOutViewModel: ObservableObject {
    @Published var currentQuestion: OddOneOutQuestion = OddOneOutQuestion.generateQuestion(for: 1)
    @Published var round: Int = 1
    @Published var isCorrect: Bool?
    @Published var showFeedback: Bool = false
    @Published var correctAnswers: Int = 0
    @Published var showResult: Bool = false
    
    func selectItem(_ item: OddOneOutItem) {
        isCorrect = item.isOdd
        showFeedback = true
        if item.isOdd {
            correctAnswers += 1
        }
    }
    
    func nextRound() {
        if round >= 10 {
            showResult = true
        } else {
            round += 1
            currentQuestion = OddOneOutQuestion.generateQuestion(for: round)
            isCorrect = nil
            showFeedback = false
        }
    }
    
    func resetGame() {
        round = 1
        correctAnswers = 0
        showResult = false
        currentQuestion = OddOneOutQuestion.generateQuestion(for: round)
        isCorrect = nil
        showFeedback = false
    }
}
