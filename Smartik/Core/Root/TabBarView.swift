//
//  TabBarView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 25.05.2025.
//

import SwiftUI

struct TabIconView: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(isSelected ? .orange : .pink)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .orange : .brown)
            }
        }
    }
}


struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab

    var body: some View {
        HStack(spacing: 40) {
            TabIconView(icon: "house.fill", label: "Home", isSelected: selectedTab == .home) {
                selectedTab = .home
            }
            TabIconView(icon: "teddybear.fill", label: "Games", isSelected: selectedTab == .games) {
                selectedTab = .games
            }
            TabIconView(icon: "chart.bar.fill", label: "Stats", isSelected: selectedTab == .statistics) {
                selectedTab = .statistics
            }
            TabIconView(icon: "person.crop.circle.fill", label: "Profile", isSelected: selectedTab == .profile) {
                selectedTab = .profile
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color(red: 1, green: 0.95, blue: 0.85))
        .clipShape(Capsule())
        .shadow(radius: 5)
    }
}

