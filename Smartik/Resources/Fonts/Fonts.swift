//
//  Fonts.swift
//  Smartik
//
//  Created by Mariia Misarosh on 23.05.2025.
//


import SwiftUI

enum Fonts: String {
    case bagelFatOne = "BagelFatOne-Regular"
    case comfortaaBold = "Comfortaa-Bold"
    case comicSansMsBold = "ComicSansMS-Bold"
    case montserratAlternatesMedium = "MontserratAlternates-Medium"
    case summaryNotes = "SummaryNotes-Regular"
}

enum AppFont {
    case bagelFatOne
    case comfortaaBold
    case comicSansMsBold
    case montserratAlternatesMedium
    case summaryNotes
    
    func font(size: CGFloat) -> Font {
        switch self {
        case .bagelFatOne:
            return .custom(Fonts.bagelFatOne.rawValue, size: size)
        case .comfortaaBold:
            return .custom(Fonts.comfortaaBold.rawValue, size: size)
        case .comicSansMsBold:
            return .custom(Fonts.comicSansMsBold.rawValue, size: size)
        case .montserratAlternatesMedium:
            return .custom(Fonts.montserratAlternatesMedium.rawValue, size: size)
        case .summaryNotes:
            return .custom(Fonts.summaryNotes.rawValue, size: size)
        }
    }
}
