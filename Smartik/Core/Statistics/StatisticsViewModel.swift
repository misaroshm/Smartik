//
//  StatisticsViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 01.06.2025.
//


import SwiftUI
import Firebase
import FirebaseAuth

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var gamesPlayed = 0
    @Published var totalCorrectAnswers = 0
    @Published var totalQuestions = 0
    @Published var bestScore = 0
    @Published var averageScore: Double = 0.0
    
    @Published var gameStats: [GameStatistics] = []
    
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    func updateStats(for game: String, correctAnswers: Int, totalQuestions: Int) {
        guard let userId = userId else { return }
        
        let ref = db.collection("users").document(userId).collection("statistics").document(game)
        
        ref.getDocument { snapshot, error in
            if let data = snapshot?.data() {
                var gamesPlayed = (data["gamesPlayed"] as? Int) ?? 0
                var previousCorrect = (data["correctAnswers"] as? Int) ?? 0
                var previousTotal = (data["totalQuestions"] as? Int) ?? 0
                var bestScore = (data["bestScore"] as? Int) ?? 0
                
                gamesPlayed += 1
                previousCorrect += correctAnswers
                previousTotal += totalQuestions
                bestScore = max(bestScore, correctAnswers)
                
                ref.setData([
                    "gamesPlayed": gamesPlayed,
                    "correctAnswers": previousCorrect,
                    "totalQuestions": previousTotal,
                    "bestScore": bestScore
                ])
            } else {
                ref.setData([
                    "gamesPlayed": 1,
                    "correctAnswers": correctAnswers,
                    "totalQuestions": totalQuestions,
                    "bestScore": correctAnswers
                ])
            }
        }
    }
    
    func loadStatistics() {
        guard let userId = userId else { return }
        
        let ref = db.collection("users").document(userId).collection("statistics")
        
        ref.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            
            var totalGames = 0
            var totalCorrect = 0
            var totalQuestions = 0
            var maxBestScore = 0
            var allGameStats: [GameStatistics] = []
            
            for doc in documents {
                let data = doc.data()
                let gamesPlayed = (data["gamesPlayed"] as? Int) ?? 0
                let correctAnswers = (data["correctAnswers"] as? Int) ?? 0
                let totalQs = (data["totalQuestions"] as? Int) ?? 0
                let best = (data["bestScore"] as? Int) ?? 0
                let gameName = doc.documentID
                
                totalGames += gamesPlayed
                totalCorrect += correctAnswers
                totalQuestions += totalQs
                if best > maxBestScore {
                    maxBestScore = best
                }
                
                let gameStat = GameStatistics(
                    gameName: gameName,
                    gamesPlayed: gamesPlayed,
                    correctAnswers: correctAnswers,
                    totalQuestions: totalQs,
                    bestScore: best
                )
                allGameStats.append(gameStat)
            }
            
            DispatchQueue.main.async {
                self.gamesPlayed = totalGames
                self.totalCorrectAnswers = totalCorrect
                self.totalQuestions = totalQuestions
                self.bestScore = maxBestScore
                self.averageScore = totalQuestions > 0 ? (Double(self.totalCorrectAnswers) / Double(totalQuestions)) * 100 : 0.0
                self.gameStats = allGameStats.sorted { $0.averageScore > $1.averageScore }
            }
        }
    }
}

