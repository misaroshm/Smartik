//
//  ResultView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 30.05.2025.
//


import SwiftUI

struct ResultView: View {
    let correctAnswers: Int
    let totalQuestions: Int
    let gameName: GameName
    let onRestart: () -> Void
    
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTab: MainTabView.Tab
    @State private var animate = false
    @StateObject private var statsVM = StatisticsViewModel()
    
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            if animate {
                Text("🎉 Чудова робота!")
                    .font(AppFont.comicSansMsBold.font(size: 30))
                    .foregroundColor(Color(red: 0, green: 0.36, blue: 0.31))
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeOut(duration: 0.6), value: animate)
                
                Text("Результат:")
                    .font(AppFont.comicSansMsBold.font(size: 30))
                    .padding(.top, 16)
                
                Text("\(correctAnswers) з \(totalQuestions) правильних")
                    .font(AppFont.comicSansMsBold.font(size: 30))
                    .padding(.bottom, 24)
                
                Text(rewardMedal)
                    .font(.system(size: 100))
                    .transition(.scale)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: animate)
                
                VStack(spacing: 8) {
                    Text("Ігор зіграно: \(RewardManager.shared.gamesPlayed)")
                    Text("Найкращий результат: \(RewardManager.shared.bestScore) правильних")
                }
                .font(AppFont.comicSansMsBold.font(size: 15))
                .padding(.bottom, 24)
                
                PrimaryButton(
                    title: "Почати знову",
                    systemImage: "arrow.counterclockwise",
                    isDisabled: false,
                    backgroundColor: Color(hex: "2BCB9A"),
                    action: onRestart
                )
                
                PrimaryButton(
                    title: "На головну",
                    systemImage: "house.fill",
                    isDisabled: false,
                    action: {
                        statsVM.updateStats(for: gameName.rawValue, correctAnswers: correctAnswers, totalQuestions: totalQuestions)
                        selectedTab = .home
                        dismiss()
                    }
                )
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .onAppear {
            animate = true
        }
    }
    
    var rewardMedal: String {
        if correctAnswers == totalQuestions {
            return "🥇"
        } else if correctAnswers >= totalQuestions / 2 {
            return "🥈"
        } else {
            return "🥉"
        }
    }
}

#Preview {
    ResultView(correctAnswers: 2, totalQuestions: 10, gameName: .oddOneOut, onRestart: {}, selectedTab: .constant(.home))
}
