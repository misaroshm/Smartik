//
//  MakeWordQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import Foundation

struct MakeWordQuestion: Identifiable {
    let id = UUID()
    let imageName: String
    let correctWord: String
}

struct Letter: Identifiable {
    let id: Int
    let char: Character
    var isUsed: Bool
}
