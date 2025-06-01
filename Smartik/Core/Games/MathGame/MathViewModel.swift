//
//  MathViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

@MainActor
class MathViewModel: ObservableObject {
    @Published var questions: [MathQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var userAnswer: String = ""
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    @Published var isGameOver: Bool = false
    @Published var feedbackColor: Color = Color.mainBackground
    
    let totalQuestions: Int
    let maxRange: Int
    let operation: OperationType
    
    init(totalQuestions: Int = 5, maxRange: Int = 10, operation: OperationType = .addition) {
        self.totalQuestions = totalQuestions
        self.maxRange = maxRange
        self.operation = operation
        generateQuestions()
    }
    
    convenience init() {
        self.init(totalQuestions: 5, maxRange: 10, operation: .addition)
    }
    
    var currentQuestion: MathQuestion {
        questions[currentIndex]
    }
    
    func generateQuestions() {
        questions = (0..<totalQuestions).map { _ in
            MathQuestion(
                firstNumber: Int.random(in: 1...maxRange),
                secondNumber: Int.random(in: 1...maxRange),
                operation: operation
            )
        }
    }
    
    func submitAnswer() {
        guard let answer = Int(userAnswer) else { return }
        
        if answer == currentQuestion.correctAnswer {
            correctAnswers += 1
            withAnimation {
                feedbackColor = .green.opacity(0.3)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.nextQuestion()
            }
        } else {
            incorrectAnswers += 1
            withAnimation {
                feedbackColor = .red.opacity(0.3)
            }
        }
    }
    
    
    private func nextQuestion() {
        feedbackColor = Color.mainBackground
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            userAnswer = ""
        } else {
            isGameOver = true
        }
    }
    
    func resetGame() {
        currentIndex = 0
        correctAnswers = 0
        incorrectAnswers = 0
        userAnswer = ""
        isGameOver = false
        feedbackColor = Color.mainBackground
        generateQuestions()
    }
}
