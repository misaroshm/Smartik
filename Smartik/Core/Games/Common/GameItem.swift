//
//  GameItem.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import Foundation
import SwiftUI

struct GameItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let category: GameCategory
    let imageName: String
    let destination: (_ selectedTab: Binding<MainTabView.Tab>) -> AnyView
    
    // navigationDestination
    static func ==(a: GameItem, b: GameItem) -> Bool { a.id == b.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}


extension GameItem {
    static let all: [GameItem] = [
        .init(title: "Memory Game",
              category: .memoryFocus,
              imageName: "memory",
              destination: { selectedTab in AnyView(MemoryGameView(selectedTab: selectedTab)) }),
        .init(title: "Odd One Out",
              category: .memoryFocus,
              imageName: "odd_one",
              destination: { selectedTab in AnyView(OddOneOutView(selectedTab: selectedTab))}),
        .init(title: "Guess the Animal",
              category: .worldNature,
              imageName: "guess_the_animal",
              destination: { selectedTab in AnyView(GuessAnimalView(selectedTab: selectedTab))}),
        .init(title: "Matching Numbers",
              category: .worldNature,
              imageName: "matching_numbers",
              destination: { selectedTab in AnyView(MatchingNumbersView(selectedTab: selectedTab))}),
        .init(title: "Make a Word",
              category: .languageAlpha,
              imageName: "make_a_word",
              destination: { selectedTab in AnyView(MakeWordView(selectedTab: selectedTab))}),
        .init(title: "Math",
              category: .math,
              imageName: "numbers",
              destination: { selectedTab in AnyView(MathSettingsView(selectedTab: selectedTab))}),
        .init(title: "Color Match",
              category: .colorsShapes,
              imageName: "color_match",
              destination: { selectedTab in AnyView(ColorMatchView(selectedTab: selectedTab))})
        //        .init(title: "Count & Match",
        //              category: .math,
        //              imageName: "count_match",
        //              destination: AnyView(CountMatchView())),
        //        .init(title: "Shape Puzzle",
        //              category: .colorsShapes,
        //              imageName: "shape_puzzle",
        //              destination: AnyView(ShapePuzzleView()))
    ]
}
