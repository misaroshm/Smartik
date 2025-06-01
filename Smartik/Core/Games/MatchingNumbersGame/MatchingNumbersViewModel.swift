//
//  MatchingNumbersViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import SwiftUI

@MainActor
class MatchingNumbersViewModel: ObservableObject {
    @Published var questions: [MatchingNumbersQuestion] = []
    @Published var currentQuestionIndex = 0
    
    @Published var selectedItem: MatchingItem? = nil
    @Published var selectedNumber: NumberItem? = nil
    @Published var showResult = false
    @Published var isCorrect: Bool? = nil
    @Published var matchedPairs: Set<UUID> = []
    
    @Published var answerFeedback: String? = nil
    @Published var correctAnswersCount = 0
    @Published var showResultView = false
    
    var currentQuestion: MatchingNumbersQuestion {
        questions[currentQuestionIndex]
    }
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        questions = [
            MatchingNumbersQuestion(
                items: [
                    MatchingItem(imageName: "jellyfish", itemCount: 3),
                    MatchingItem(imageName: "whale", itemCount: 2),
                    MatchingItem(imageName: "fish", itemCount: 5)
                ].shuffled(),
                numbers: [
                    NumberItem(imageName: "3", number: 3),
                    NumberItem(imageName: "2", number: 2),
                    NumberItem(imageName: "5", number: 5)
                ].shuffled()
            ),
            
            MatchingNumbersQuestion(
                items: [
                    MatchingItem(imageName: "bird", itemCount: 5),
                    MatchingItem(imageName: "moose", itemCount: 3),
                    MatchingItem(imageName: "walrus", itemCount: 6)
                ].shuffled(),
                numbers: [
                    NumberItem(imageName: "5", number: 5),
                    NumberItem(imageName: "3", number: 3),
                    NumberItem(imageName: "6", number: 6)
                ].shuffled()
            ),
            
            MatchingNumbersQuestion(
                items: [
                    MatchingItem(imageName: "mouse", itemCount: 1),
                    MatchingItem(imageName: "rabit", itemCount: 4),
                    MatchingItem(imageName: "lutra", itemCount: 2)
                ].shuffled(),
                numbers: [
                    NumberItem(imageName: "1", number: 1),
                    NumberItem(imageName: "4", number: 4),
                    NumberItem(imageName: "2", number: 2)
                ].shuffled()
            )
        ]
    }
    
    
    func selectItem(_ item: MatchingItem) {
        guard !matchedPairs.contains(item.id) else { return }
        selectedItem = item
    }
    
    func selectNumber(_ number: NumberItem) {
        selectedNumber = number
    }
    
    func checkAnswer() {
        guard let selectedItem, let selectedNumber else { return }
        let correct = selectedItem.itemCount == selectedNumber.number
        isCorrect = correct
        if correct {
            matchedPairs.insert(selectedItem.id)
            correctAnswersCount += 1
            answerFeedback = "Правильно! 🎉"
        } else {
            answerFeedback = "Неправильно 😢"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.answerFeedback = nil
        }
        
        self.selectedItem = nil
        self.selectedNumber = nil
    }
    
    
    func goToNext() {
        selectedItem = nil
        selectedNumber = nil
        isCorrect = nil
        showResult = false
        matchedPairs = []
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            showResultView = true
        }
    }
    
    
    func isNumberMatched(_ number: NumberItem) -> Bool {
        return currentQuestion.items.contains {
            matchedPairs.contains($0.id) && $0.itemCount == number.number
        }
    }
    
    func isFinished() -> Bool {
        return matchedPairs.count == currentQuestion.items.count
    }
    
}
