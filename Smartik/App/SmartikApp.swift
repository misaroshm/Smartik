//
//  SmartikApp.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI
import Firebase

@main
struct SmartikApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
