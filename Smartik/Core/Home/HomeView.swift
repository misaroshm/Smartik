//
//  HomeView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 26.05.2025.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                BackgroundWithImage {
                    HomeScreenContent(
                        childName: viewModel.currentUser?.childName ?? "Friend",
                        onStart: { selectedTab = .games }
                    )
                }
                .ignoresSafeArea()
            }
        }
    }
}


struct HomeScreenContent: View {
    let childName: String
    let onStart: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Привітання
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello Little,")
                    .font(AppFont.montserratAlternatesMedium.font(size: 30))
                    .foregroundColor(.white)
                
                Text("\(childName.uppercased())!")
                    .font(AppFont.summaryNotes.font(size: 60))
                    .foregroundColor(.white)
            }
            .padding(.top,  UIScreen.main.bounds.height * 0.07)
            .padding(.leading, 20)
            
            Spacer()
            
            // Кнопка START
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPressed = false
                        onStart()
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("🚀 Почати")
                        Image(systemName: "play")
                    }
                    .font(AppFont.comfortaaBold.font(size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(Color.yellow)
                    .cornerRadius(30)
                    .shadow(radius: 5)
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.bottom,  UIScreen.main.bounds.height * 0.20)
            Spacer()
        }
        Spacer()
    }
}

#Preview {
    let mockVM = AuthViewModel()
    mockVM.currentUser = User.MOCK_USER
    
    return HomeView(selectedTab: .constant(.games))
        .environmentObject(mockVM)
}
