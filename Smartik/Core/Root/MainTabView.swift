//
//  MainTabView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, games, statistics, profile
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(selectedTab: $selectedTab)
                    case .games:
                        GamesView(selectedTab: $selectedTab)
                    case .statistics:
                        StatisticsView()
                    case .profile:
                        ProfileView()
                    }

                }
                .frame(width: geo.size.width, height: geo.size.height - 80)
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? geo.safeAreaInsets.bottom : 10)
                    .frame(height: 80 + (geo.safeAreaInsets.bottom))
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}



#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
