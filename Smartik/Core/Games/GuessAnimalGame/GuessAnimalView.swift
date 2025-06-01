//
//  GuessAnimalView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//


import SwiftUI

struct GuessAnimalView: View {
    @StateObject private var viewModel = GuessAnimalViewModel()
    @Namespace private var animation
    @State private var selectedOption: String? = nil
    
    @Binding var selectedTab: MainTabView.Tab
    
    
    var body: some View {
        VStack(spacing: 24) {
            // Прогрес
            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.totalQuestions))
                .padding(.horizontal)
                .accentColor(.green)
            
            Spacer()
            
            // Питання
            Text("Хто це?")
                .font(AppFont.comicSansMsBold.font(size: 40))
            
            // Картинка
            Image(viewModel.currentQuestion.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220)
                .shadow(radius: 8)
                .padding()
                .scaleEffect(viewModel.selectedAnswer == nil ? 1 : 1.05)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: viewModel.selectedAnswer)
            
            // Варіанти відповіді
            VStack(spacing: 12) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                    GameOptionButton(
                        title: option,
                        backgroundColor: buttonColor(option),
                        isSelected: selectedOption == option,
                        action: {
                            if viewModel.selectedAnswer == nil {
                                selectedOption = option
                                withAnimation {
                                    viewModel.checkAnswer(option)
                                }
                            }
                        }
                    )
                    .disabled(viewModel.selectedAnswer != nil)
                }
            }
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.4), value: viewModel.currentIndex)
            
            
            // Кнопка
            if viewModel.selectedAnswer != nil {
                PrimaryButton(
                    title: viewModel.isLastQuestion ? "Завершити" : "Наступне",
                    systemImage: "arrow.right",
                    isDisabled: false,
                    backgroundColor: Color(hex: "F15D41"),
                    action: {
                        withAnimation {
                            viewModel.nextQuestion()
                            selectedOption = nil
                        }
                    }
                )
                .padding(.top)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.showResult) {
            ResultView(
                correctAnswers: viewModel.correctAnswersCount,
                totalQuestions: viewModel.totalQuestions,
                gameName: .guessAnimal,
                onRestart: {
                    viewModel.resetGame()
                },
                selectedTab: $selectedTab
            )
        }
    }
    
    private func buttonColor(_ option: String) -> Color {
        if viewModel.selectedAnswer == nil {
            return Color(hex: "FFCF25")
        } else if option == viewModel.currentQuestion.correctAnswer {
            return Color(hex: "2BCB9A")
        } else if option == selectedOption {
            return Color(hex: "EF3349")
        } else {
            return Color.gray
        }
    }
}

class RewardManager {
    static let shared = RewardManager()
    private init() {}
    
    @AppStorage("candies") var candies = 0
    @AppStorage("gamesPlayed") var gamesPlayed = 0
    @AppStorage("bestScore") var bestScore = 0
    
    func addCandies(_ amount: Int) {
        candies += amount
    }
    
    func resetCandies() {
        candies = 0
    }
    
    func updateStats(correctAnswers: Int, totalQuestions: Int) {
        gamesPlayed += 1
        if correctAnswers > bestScore {
            bestScore = correctAnswers
        }
    }
}

#Preview {
    GuessAnimalView(selectedTab: .constant(.home))
}
