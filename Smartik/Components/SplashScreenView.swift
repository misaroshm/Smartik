//
//  SplashScreenView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 23.05.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity = 0.0
    @State private var isAnimationCompleted = false

    var body: some View {
        ZStack {
            Color(hex: "#005B50")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("logo_icon")
                    .resizable()
                    .frame(width: 170, height: 170)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Text("SMARTIK")
                    .font(AppFont.bagelFatOne.font(size: 64))
                    .foregroundColor(Color(hex: "#F9F871"))
                    .shadow(radius: 4)
                    .opacity(logoOpacity)
            }
        }
        .onAppear {
            startSplashAnimation()
        }
        .task {
            if isAnimationCompleted {
                print("Анімація завершена — стартуємо логіку")
                await viewModel.startApp()
            }
        }
    }

    private func startSplashAnimation() {
        withAnimation(.easeIn(duration: 5)) {
            self.logoScale = 1.0
            self.logoOpacity = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isAnimationCompleted = true
        }
    }
}




#Preview {
    SplashScreenView()
        .environmentObject(AuthViewModel())
}
