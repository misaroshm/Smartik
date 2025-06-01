//
//  CardModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import Foundation

struct MemoryCard: Identifiable {
    let id: UUID = UUID()
    let content: String 
    var isMatched: Bool = false
    var isFlipped: Bool = false
}
