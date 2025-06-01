//
//  ContentView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        switch viewModel.appState {
        case .splash:
            SplashScreenView()
        case .auth:
            LoginView()
        case .onboarding:
            ChildSetupView()
        case .main:
            MainTabView()
        }
    }
}

#Preview {
    ContentView()
}
