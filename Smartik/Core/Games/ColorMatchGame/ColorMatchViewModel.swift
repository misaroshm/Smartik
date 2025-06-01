//
//  ColorMatchViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

@MainActor
class ColorMatchViewModel: ObservableObject {
    @Published var questions: [ColorMatchQuestion] = []
    @Published var currentIndex = 0
    @Published var selectedColor: Color? = nil
    @Published var showResult = false
    @Published var isCorrect = false
    @Published var correctAnswersCount = 0
    @Published var isGameOver = false
    
    var currentQuestion: ColorMatchQuestion {
        questions[currentIndex]
    }
    
    var totalQuestions: Int {
        questions.count
    }
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        questions = [
            ColorMatchQuestion(imageName: "star", correctColor: .yellow, options: [.yellow, .blue, .red].shuffled()),
            ColorMatchQuestion(imageName: "cloud", correctColor: .blue, options: [.blue, .white, .purple].shuffled()),
            ColorMatchQuestion(imageName: "heart", correctColor: .red, options: [.red, .pink, .blue].shuffled()),
            ColorMatchQuestion(imageName: "leaf", correctColor: .green, options: [.green, .brown, .orange].shuffled()),
            ColorMatchQuestion(imageName: "sunn", correctColor: .yellow, options: [.yellow, .orange, .blue].shuffled()),
            ColorMatchQuestion(imageName: "butterflyy", correctColor: .purple, options: [.purple, .green, .red].shuffled())
        ]
    }
    
    func selectColor(_ color: Color) {
        selectedColor = color
        isCorrect = (color == currentQuestion.correctColor)
        if isCorrect {
            correctAnswersCount += 1
        }
        showResult = true
    }
    
    func nextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            selectedColor = nil
            showResult = false
        } else {
            isGameOver = true
        }
    }
    
    func resetGame() {
        currentIndex = 0
        selectedColor = nil
        showResult = false
        correctAnswersCount = 0
        isGameOver = false
        loadQuestions()
    }
}

