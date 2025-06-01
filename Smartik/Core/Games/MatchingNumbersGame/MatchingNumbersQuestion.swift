//
//  MatchingNumbersQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import SwiftUI

struct MatchingItem: Identifiable {
    let id = UUID()
    let imageName: String
    let itemCount: Int
}

struct NumberItem: Identifiable {
    let id = UUID()
    let imageName: String
    let number: Int
}

struct MatchingNumbersQuestion: Identifiable {
    let id = UUID()
    let items: [MatchingItem]
    let numbers: [NumberItem]
}
