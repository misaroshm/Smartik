//
//  ViewExtension.swift
//  Smartik
//
//  Created by Mariia Misarosh on 30.05.2025.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.endEditing()
            }
        )
    }
}
