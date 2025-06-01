//
//  MathView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI


struct MathView: View {
    @StateObject private var viewModel = MathViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    init(totalQuestions: Int, maxRange: Int, operation: OperationType, selectedTab: Binding<MainTabView.Tab>) {
        _viewModel = StateObject(wrappedValue: MathViewModel(
            totalQuestions: totalQuestions,
            maxRange: maxRange,
            operation: operation
        ))
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.totalQuestions))
                .accentColor(.mint)
                .padding(.horizontal)
            
            Spacer()
            Text("Напиши відповідь")
                .font(AppFont.comicSansMsBold.font(size: 36))
            
            Text(viewModel.currentQuestion.questionText)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(Color(red: 0, green: 0.36, blue: 0.31))
            
            TextField("Ваша відповідь", text: $viewModel.userAnswer)
                .keyboardType(.numbersAndPunctuation)
                .padding()
                .frame(width: 200, height: 60)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            PrimaryButton(
                title: "Відповісти",
                systemImage: "arrow.right",
                isDisabled: viewModel.userAnswer.isEmpty,
                action: {
                    viewModel.submitAnswer()
                }
            )
            
            Spacer()
        }
        .padding()
        .background(viewModel.feedbackColor.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.isGameOver) {
            ResultView(
                correctAnswers: viewModel.correctAnswers,
                totalQuestions: viewModel.totalQuestions,
                gameName: .mathGame,
                onRestart: {
                    viewModel.resetGame()
                },
                selectedTab: $selectedTab
            )
        }
    }
}
