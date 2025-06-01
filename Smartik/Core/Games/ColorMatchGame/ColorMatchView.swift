//
//  ColorMatchView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

struct ColorMatchView: View {
    @StateObject private var viewModel = ColorMatchViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.totalQuestions))
                .padding(.horizontal)
                .accentColor(.mint)
            
            Spacer()
            
            Text("Який це колір?")
                .font(AppFont.comicSansMsBold.font(size: 36))
            
            Image(viewModel.currentQuestion.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            HStack(spacing: 16) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { color in
                    Button(action: {
                        withAnimation {
                            viewModel.selectColor(color)
                        }
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: viewModel.selectedColor == color ? 4 : 0)
                            )
                    }
                    .disabled(viewModel.showResult)
                }
            }
            
            if viewModel.showResult {
                PrimaryButton(
                    title: viewModel.isCorrect ? "Правильно!" : "Спробуй ще",
                    systemImage: viewModel.isCorrect ? "checkmark" : "arrow.right",
                    isDisabled: false,
                    action: {
                        withAnimation {
                            viewModel.nextQuestion()
                        }
                    }
                )
                .padding(.top)
                .transition(.scale)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.isGameOver) {
            ResultView(
                correctAnswers: viewModel.correctAnswersCount,
                totalQuestions: viewModel.totalQuestions,
                gameName: .colorMatch,
                onRestart: {
                    viewModel.resetGame()
                },
                selectedTab: $selectedTab
            )
        }
    }
}


#Preview {
    ColorMatchView(selectedTab: .constant(.home))
}
