//
//  GuessAnimalViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//


import SwiftUI

@MainActor
class GuessAnimalViewModel: ObservableObject {
    @Published var questions: [GuessAnimalQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: String? = nil
    @Published var showResult = false
    @Published var correctAnswersCount = 0
    
    var currentQuestion: GuessAnimalQuestion {
        questions[currentIndex]
    }
    
    var totalQuestions: Int {
        questions.count
    }
    
    var isLastQuestion: Bool {
        currentIndex == questions.count - 1
    }
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        questions = [
            GuessAnimalQuestion(imageName: "fox", correctAnswer: "Лисиця", options: ["Лисиця", "Кішка", "Ведмідь"]),
            GuessAnimalQuestion(imageName: "elephant", correctAnswer: "Слон", options: ["Собака", "Слон", "Жирафа"]),
            GuessAnimalQuestion(imageName: "lion", correctAnswer: "Лев", options: ["Тигр", "Лев", "Пантера"]),
            GuessAnimalQuestion(imageName: "giraffe", correctAnswer: "Жирафа", options: ["Зебра", "Жирафа", "Кінь"]),
            GuessAnimalQuestion(imageName: "penguin", correctAnswer: "Пінгвін", options: ["Гуска", "Пінгвін", "Лебідь"]),
            GuessAnimalQuestion(imageName: "panda", correctAnswer: "Панда", options: ["Ведмідь", "Панда", "Кіт"]),
            GuessAnimalQuestion(imageName: "zebra", correctAnswer: "Зебра", options: ["Конячка", "Косуля", "Зебра"]),
            GuessAnimalQuestion(imageName: "kangaroo", correctAnswer: "Кенгуру", options: ["Кролик", "Кенгуру", "Олень"]),
            GuessAnimalQuestion(imageName: "monkey", correctAnswer: "Мавпа", options: ["Мавпа", "Лемур", "Собака"]),
            GuessAnimalQuestion(imageName: "dolphin", correctAnswer: "Дельфін", options: ["Дельфін", "Кіт", "Риба"])
        ]
    }
    
    func checkAnswer(_ answer: String) {
        selectedAnswer = answer
        if answer == currentQuestion.correctAnswer {
            correctAnswersCount += 1
        }
    }
    
    func nextQuestion() {
        if isLastQuestion {
            showResult = true
            RewardManager.shared.updateStats(correctAnswers: correctAnswersCount, totalQuestions: totalQuestions)
        } else {
            currentIndex += 1
            selectedAnswer = nil
        }
    }
    
    func resetGame() {
        correctAnswersCount = 0
        currentIndex = 0
        selectedAnswer = nil
        showResult = false
        loadQuestions()
    }
}

