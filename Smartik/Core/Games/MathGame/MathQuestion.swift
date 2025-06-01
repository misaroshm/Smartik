//
//  MathQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import Foundation

enum OperationType: String, CaseIterable, Identifiable {
    case addition
    case subtraction
    case multiplication
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        }
    }
}

struct MathQuestion: Identifiable {
    let id = UUID()
    let firstNumber: Int
    let secondNumber: Int
    let operation: OperationType
    
    var correctAnswer: Int {
        switch operation {
        case .addition: return firstNumber + secondNumber
        case .subtraction: return firstNumber - secondNumber
        case .multiplication: return firstNumber * secondNumber
        }
    }
    
    var questionText: String {
        "\(firstNumber) \(operation.symbol) \(secondNumber) = ?"
    }
}
