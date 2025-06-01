//
//  OddOneOutView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import SwiftUI

import SwiftUI

struct OddOneOutView: View {
    @StateObject private var viewModel = OddOneOutViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView(value: Double(viewModel.round), total: 10)
                .padding(.horizontal)
                .accentColor(.green)
            
            Text("Раунд \(viewModel.round)")
                .font(AppFont.comicSansMsBold.font(size: 36))
                .padding(.top)
            
            Spacer()
            
            Text("Знайди зайве")
                .font(AppFont.comicSansMsBold.font(size: 36))
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                ForEach(viewModel.currentQuestion.items) { item in
                    VStack {
                        if item.isImage {
                            Image(item.content)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        } else {
                            Text(item.content)
                                .font(.largeTitle)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .onTapGesture {
                        viewModel.selectItem(item)
                    }
                    .overlay(
                        viewModel.showFeedback && viewModel.isCorrect != nil
                        ? RoundedRectangle(cornerRadius: 12)
                            .stroke(item.isOdd ? Color.green : Color.red, lineWidth: 3)
                        : nil
                    )
                }
            }
            .padding(.top)
            Spacer()
            
            if viewModel.showFeedback {
                VStack {
                    Text(viewModel.isCorrect == true ? "✅ Правильно!" : "❌ Неправильно")
                        .font(AppFont.comicSansMsBold.font(size: 20))
                        .foregroundColor(viewModel.isCorrect == true ? Color(hex: "#2BCB9A") : Color(hex: "#EF3349"))
                    
                    PrimaryButton(
                        title: "Продовжити",
                        systemImage: "arrow.right",
                        isDisabled: false,
                        action: {
                            viewModel.nextRound()
                        }
                    )
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.showResult) {
            ResultView(
                correctAnswers: viewModel.correctAnswers,
                totalQuestions: 10,
                gameName: .oddOneOut,
                onRestart: {
                    viewModel.resetGame()
                },
                selectedTab: $selectedTab
            )
        }
    }
}

#Preview {
    OddOneOutView(selectedTab: .constant(.home))
}
