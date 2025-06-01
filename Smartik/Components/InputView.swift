//
//  InputView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct InputView<TrailingIcon: View>: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var iconName: String? = nil
    var trailingIcon: (() -> TrailingIcon)?
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .font(AppFont.comfortaaBold.font(size: 15))
            
            HStack {
                if let icon = iconName {
                    Image(systemName: icon)
                        .foregroundColor(.gray)
                }
                
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .font(AppFont.comfortaaBold.font(size: 15))
                }
                
                if let trailing = trailingIcon {
                    trailing()
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(isFocused ? Color(red: 0, green: 0.36, blue: 0.31) : Color.gray.opacity(0.4), lineWidth: 3)
            )
        }
    }
}


extension InputView where TrailingIcon == EmptyView {
    init(text: Binding<String>, title: String, placeholder: String, isSecureField: Bool = false, iconName: String? = nil) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.isSecureField = isSecureField
        self.iconName = iconName
        self.trailingIcon = nil
    }
}


#Preview {
    InputView(text: .constant(""), title: "Password", placeholder: "Enter password", isSecureField: true, iconName: "lock")
}

