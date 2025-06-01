//
//  PrimaryButton.swift
//  Smartik
//
//  Created by Mariia Misarosh on 23.05.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let systemImage: String
    let isDisabled: Bool
    let action: () -> Void
    let backgroundColor: Color
    
    init(
        title: String,
        systemImage: String,
        isDisabled: Bool = false,
        backgroundColor: Color = Color(red: 0, green: 0.36, blue: 0.31),
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isDisabled = isDisabled
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .font(AppFont.comfortaaBold.font(size: 20))
                Image(systemName: systemImage)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(backgroundColor)
            .cornerRadius(30)
            .padding(.horizontal, 32)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview {
    PrimaryButton(
        title: "Sign In",
        systemImage: "arrow.right",
        isDisabled: false
    ) {
        print("Clicked!")
    }
}
