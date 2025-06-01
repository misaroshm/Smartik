//
//  ColorMatchQuestion.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

struct ColorMatchQuestion: Identifiable {
    let id = UUID()
    let imageName: String
    let correctColor: Color
    let options: [Color]
}
