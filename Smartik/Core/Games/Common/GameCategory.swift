//
//  GameCategory.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//


import Foundation
import SwiftUI

enum GameCategory: String, CaseIterable, Identifiable {
    case memoryFocus    = "Memory & Focus"
    case worldNature    = "World & Nature"
    case languageAlpha  = "Language & Alphabet"
    case math            = "Math"
    case colorsShapes    = "Colors & Shapes"
    
    var id: Self { self }
    var icon: String {
        switch self {
        case .memoryFocus:   return "brain.head.profile"
        case .worldNature:   return "leaf"
        case .languageAlpha: return "text.book.closed"
        case .math:          return "sum"
        case .colorsShapes:  return "paintpalette"
        }
    }
    
    var color: Color {
        switch self {
        case .memoryFocus:   return .purple
        case .worldNature:   return .green
        case .languageAlpha: return .blue
        case .math:          return .orange
        case .colorsShapes:  return .pink
        }
    }
    
}
