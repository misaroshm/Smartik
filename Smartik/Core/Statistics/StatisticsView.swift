//
//  StatisticsView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import Charts
import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("📊 Моя Статистика")
                    .font(AppFont.comfortaaBold.font(size: 25))
                    .padding()
                
                generalStatisticsSection
                
                Divider()
                    .padding(.vertical)
                
                if !viewModel.gameStats.isEmpty {
                    Text("Статистика по іграх")
                        .font(AppFont.comfortaaBold.font(size: 15))
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.gameStats) { stat in
                            gameStatCard(for: stat)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                    .padding(.vertical)
                
                if !viewModel.gameStats.isEmpty {
                    Text("Середній відсоток правильних")
                        .font(AppFont.comfortaaBold.font(size: 15))
                        .padding(.bottom, 8)
                    
                    BarChartView(stats: viewModel.gameStats)
                        .frame(height: 300)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color.mainBackground)
        .onAppear {
            viewModel.loadStatistics()
        }
    }
    
    var generalStatisticsSection: some View {
        VStack(spacing: 16) {
            statRow(label: "Ігор зіграно:", value: "\(viewModel.gamesPlayed)")
            
            statRow(label: "Правильних відповідей:", value: "\(viewModel.totalCorrectAnswers)")
            statRow(label: "Усього питань:", value: "\(viewModel.totalQuestions)")
            statRow(label: "Найкращий результат:", value: "\(viewModel.bestScore)")
            statRow(label: "Середній % правильних:", value: String(format: "%.1f%%", viewModel.averageScore))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .font(AppFont.comfortaaBold.font(size: 15))
        .shadow(radius: 5)
    }
    
    func gameStatCard(for stat: GameStatistics) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(stat.emoji) \(stat.displayName)")
                    .font(.headline)
                Spacer()
                Text(medal(for: stat.bestScore))
                    .font(AppFont.comfortaaBold.font(size: 10))
            }
            
            statRow(label: "Ігор:", value: "\(stat.gamesPlayed)")
            statRow(label: "Правильних:", value: "\(stat.correctAnswers)")
            statRow(label: "Питань:", value: "\(stat.totalQuestions)")
            statRow(label: "Найкращий результат:", value: "\(stat.bestScore)")
            statRow(label: "Середній %:", value: String(format: "%.1f%%", stat.averageScore))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .font(AppFont.comfortaaBold.font(size: 10))
        .shadow(radius: 3)
    }
    
    func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .bold()
        }
    }
    
    func medal(for score: Int) -> String {
        switch score {
        case 10...:
            return "🏆"
        case 7..<10:
            return "🥇"
        case 4..<7:
            return "🥈"
        default:
            return "🥉"
        }
    }
}

struct BarChartView: View {
    let stats: [GameStatistics]
    
    var body: some View {
        Chart {
            ForEach(stats) { stat in
                BarMark(
                    x: .value("Гра", stat.displayName),
                    y: .value("%", stat.averageScore)
                )
                .foregroundStyle(.blue)
            }
        }
    }
}




#Preview {
    StatisticsView()
}
