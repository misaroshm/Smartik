//
//  GuessAnimalQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import SwiftUI
import Foundation

struct GuessAnimalQuestion: Identifiable {
    let id = UUID()
    let imageName: String
    let correctAnswer: String
    let options: [String]
}
