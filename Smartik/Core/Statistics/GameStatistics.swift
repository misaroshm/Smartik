//
//  GameStatistics.swift
//  Smartik
//
//  Created by Mariia Misarosh on 01.06.2025.
//


import Foundation

struct GameStatistics: Identifiable {
    var id: String { gameName }
    let gameName: String
    let gamesPlayed: Int
    let correctAnswers: Int
    let totalQuestions: Int
    let bestScore: Int
    
    var averageScore: Double {
        totalQuestions > 0 ? min((Double(correctAnswers) / Double(totalQuestions)) * 100, 100.0) : 0.0
    }
    
    var displayName: String {
        GameName(rawValue: gameName)?.displayName ?? gameName
    }
    
    var emoji: String {
        GameName(rawValue: gameName)?.emoji ?? "🎯"
    }
}


enum GameName: String, CaseIterable {
    case memoryGame = "memoryGame"
    case oddOneOut = "oddOneOut"
    case colorMatch = "colorMatch"
    case mathGame = "mathGame"
    case makeWord = "makeWord"
    case guessAnimal = "guessAnimal"
    case matchingNumbers = "matchingNumbers"
    
    var displayName: String {
        switch self {
        case .memoryGame: return "Пам'ять"
        case .oddOneOut: return "Хто зайвий"
        case .colorMatch: return "Кольори"
        case .mathGame: return "Математика"
        case .makeWord: return "Склади слово"
        case .guessAnimal: return "Вгадай тварину"
        case .matchingNumbers: return "Порахуй числа"
        }
    }
    
    var emoji: String {
        switch self {
        case .memoryGame: return "🧠"
        case .oddOneOut: return "🧐"
        case .colorMatch: return "🎨"
        case .mathGame: return "➕"
        case .makeWord: return "🔤"
        case .guessAnimal: return "🐾"
        case .matchingNumbers: return "🔢"
        }
    }
}

