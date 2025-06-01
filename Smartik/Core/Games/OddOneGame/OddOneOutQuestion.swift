//
//  OddOneOutQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import Foundation

struct OddOneOutQuestion {
    let items: [OddOneOutItem]
    
    static func generateQuestion(for round: Int) -> OddOneOutQuestion {
        let animalGroup = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊"].shuffled()
        let fruitGroup = ["🍏", "🍎", "🍐", "🍇", "🍓", "🍒"].shuffled()
        let transportGroup = ["✈️", "🚗", "🚲", "🛴", "🛵", "🚀"].shuffled()
        
        let oddOnes = ["🍔", "⚽️", "📚", "💡", "🎈", "🎁"]
        
        let groups = [animalGroup, fruitGroup, transportGroup]
        
        let group = groups.randomElement()!.shuffled().prefix(3)
        let odd = oddOnes.randomElement()!
        
        var items = group.map { OddOneOutItem(content: $0, isOdd: false, isImage: false) }
        items.append(OddOneOutItem(content: odd, isOdd: true, isImage: false))
        
        return OddOneOutQuestion(items: items.shuffled())
    }
}
