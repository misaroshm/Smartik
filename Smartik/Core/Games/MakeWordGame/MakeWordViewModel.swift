//
//  MakeWordViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI


@MainActor
class MakeWordViewModel: ObservableObject {
    @Published var questions: [MakeWordQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var selectedLetters: [Character?] = []
    @Published var letterOptions: [Letter] = []
    @Published var showResult: Bool = false
    
    var currentQuestion: MakeWordQuestion {
        questions[currentIndex]
    }
    
    var targetWord: [Character] {
        Array(currentQuestion.correctWord.uppercased())
    }
    
    init() {
        loadQuestions()
        setupCurrentQuestion()
    }
    
    func loadQuestions() {
        questions = [
            MakeWordQuestion(imageName: "sun", correctWord: "СОНЦЕ"),
            MakeWordQuestion(imageName: "flower", correctWord: "КВІТКА"),
            MakeWordQuestion(imageName: "book", correctWord: "КНИГА"),
            MakeWordQuestion(imageName: "water", correctWord: "ВОДА")
        ]
    }
    
    func setupCurrentQuestion() {
        selectedLetters = Array(repeating: nil, count: targetWord.count)
        
        var pool = targetWord
        let extraLetters = "АБВГДЖЗІЙКЛМНОПРСТУФХЧШ".shuffled()
        pool.append(contentsOf: extraLetters.prefix(2)) // зайві літери
        pool.shuffle()
        
        letterOptions = pool.enumerated().map { idx, ch in
            Letter(id: idx, char: ch, isUsed: false)
        }
    }
    
    func letterTapped(_ letter: Letter) {
        if let slot = selectedLetters.firstIndex(where: { $0 == nil }) {
            selectedLetters[slot] = letter.char
            if let idx = letterOptions.firstIndex(where: { $0.id == letter.id }) {
                letterOptions[idx].isUsed = true
            }
        }
    }
    
    func removeLetter(at index: Int) {
        guard let letter = selectedLetters[index] else { return }
        selectedLetters[index] = nil
        if let idx = letterOptions.firstIndex(where: { $0.char == letter && $0.isUsed }) {
            letterOptions[idx].isUsed = false
        }
    }
    
    func checkAnswer() {
        let attempt = selectedLetters.compactMap { $0 }
        if attempt == targetWord {
            if currentIndex + 1 < questions.count {
                currentIndex += 1
                setupCurrentQuestion()
            } else {
                showResult = true
            }
        } else {
            resetCurrentQuestion()
        }
    }
    
    func resetCurrentQuestion() {
        selectedLetters = Array(repeating: nil, count: targetWord.count)
        for i in letterOptions.indices {
            letterOptions[i].isUsed = false
        }
    }
    
    func restartGame() {
        currentIndex = 0
        showResult = false
        setupCurrentQuestion()
    }
}

