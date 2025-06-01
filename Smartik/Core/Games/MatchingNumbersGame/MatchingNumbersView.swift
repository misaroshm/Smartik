//
//  MatchingNumbersView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//


import SwiftUI

struct MatchingNumbersView: View {
    @StateObject private var viewModel = MatchingNumbersViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: Double(viewModel.currentQuestionIndex + 1), total: Double(viewModel.questions.count))
                .padding(.horizontal)
                .accentColor(.mint)
            
            Spacer()
            
            Text("Скільки об'єктів?")
                .font(AppFont.comicSansMsBold.font(size: 36))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)) {
                ForEach(viewModel.currentQuestion.items) { item in
                    CardView(
                        imageName: item.imageName,
                        isSelected: viewModel.selectedItem?.id == item.id,
                        isMatched: viewModel.matchedPairs.contains(item.id)
                    )
                    .onTapGesture {
                        viewModel.selectItem(item)
                    }
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)) {
                ForEach(viewModel.currentQuestion.numbers) { number in
                    CardView(
                        imageName: number.imageName,
                        isSelected: viewModel.selectedNumber?.id == number.id,
                        isMatched: viewModel.isNumberMatched(number)
                    )
                    .onTapGesture {
                        viewModel.selectNumber(number)
                    }
                }
            }
            .padding(.horizontal)
            
            if let feedback = viewModel.answerFeedback {
                Text(feedback)
                    .font(.headline)
                    .foregroundColor(viewModel.isCorrect == true ? .green : .red)
                    .transition(.opacity)
            }
            
            if viewModel.selectedItem != nil && viewModel.selectedNumber != nil {
                PrimaryButton(
                    title: "Перевірити",
                    systemImage: "checkmark",
                    isDisabled: false,
                    backgroundColor: Color(hex: "EF3349"),
                    action: {
                        withAnimation {
                            viewModel.checkAnswer()
                        }
                    }
                )
            }
            
            if viewModel.isFinished() {
                PrimaryButton(
                    title: "Наступне",
                    systemImage: "arrow.right",
                    isDisabled: false,
                    backgroundColor: Color(hex: "EF3349"),
                    action: {
                        withAnimation {
                            viewModel.goToNext()
                        }
                    }
                )
            }
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showResultView, onDismiss: resetGame) {
            ResultView(
                correctAnswers: viewModel.correctAnswersCount,
                totalQuestions: viewModel.questions.count,
                gameName: .matchingNumbers,
                onRestart: {
                    resetGame()
                    viewModel.showResultView = false
                },
                selectedTab: $selectedTab
            )
        }
    }
    
    func resetGame() {
        viewModel.currentQuestionIndex = 0
        viewModel.correctAnswersCount = 0
        viewModel.loadQuestions()
    }
}


#Preview {
    MatchingNumbersView(selectedTab: .constant(.home))
}
