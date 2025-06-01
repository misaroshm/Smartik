//
//  GamesView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 26.05.2025.
//

import SwiftUI

struct GamesView: View {
    @Binding var selectedTab: MainTabView.Tab
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer().frame(height: 60)
                Text("Ігри")
                    .font(AppFont.comicSansMsBold.font(size: 25))
                
                LazyVStack(alignment: .leading, spacing: 32) {
                    ForEach(GameCategory.allCases) { category in
                        HStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .foregroundColor(category.color)
                                .frame(height: 30)
                            
                            Text(category.rawValue)
                                .font(AppFont.comicSansMsBold.font(size: 25))
                        }
                        .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(GameItem.all.filter { $0.category == category }) { item in
                                NavigationLink(value: item) {
                                    VStack(spacing: 8) {
                                        Image(item.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 50)
                                        Text(item.title)
                                            .font(AppFont.comfortaaBold.font(size: 13))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.primary)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
                .padding(.bottom, 120)
            }
            .background(Color.mainBackground)
            .ignoresSafeArea()
            .navigationDestination(for: GameItem.self) { item in
                item.destination($selectedTab)
            }
        }
        .background(Color.mainBackground)
    }
}

#Preview {
    GamesView(selectedTab: .constant(.home))
    .environmentObject(AuthViewModel())}
