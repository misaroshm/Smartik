//
//  SettingsRowView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(AppFont.comfortaaBold.font(size: 15))
                .foregroundColor(Color(.black))
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
