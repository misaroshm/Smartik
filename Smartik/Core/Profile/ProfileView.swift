//
//  ProfileView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                ScrollView {
                    VStack(spacing: 24) {
                        profileCard(for: user)
                            .padding(.top, 40)
                        
                        List {
                            Section {
                                NavigationLink(destination: ChildSetupView(isEditing: true)) {
                                    Label("Редагувати профіль", systemImage: "pencil")
                                }
                            }
                            
                            Section {
                                NavigationLink(destination: ParentSettingsView()) {
                                    Label("Налаштування акаунта", systemImage: "gearshape")
                                }
                            }
                            
                        }
                        .frame(height: 250)
                        .listStyle(InsetGroupedListStyle())
                        .scrollContentBackground(.hidden)
                        .font(AppFont.comfortaaBold.font(size: 17))
                        .padding(.top, 20)
                        
                    }
                }
                .navigationTitle("Профіль")
                .background(Color.mainBackground.ignoresSafeArea())
            } else {
                ProgressView("Завантаження...")
                    .task {
                        await viewModel.fetchUser()
                    }
            }
        }
        .background(Color.mainBackground.ignoresSafeArea())
    }
    
    @ViewBuilder
    func profileCard(for user: User) -> some View {
        VStack(spacing: 16) {
            Image(user.avatarName ?? "avatar1")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 6)
            
            Text(user.childName ?? "Ім’я не вказане")
                .font(AppFont.comfortaaBold.font(size: 20))
            
            
            if let age = user.childAge {
                Text("\(age) років")
                    .font(AppFont.comfortaaBold.font(size: 20))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .background(Color.mainBackground)
    }
    
    
}

#Preview {
    let mockUser = User.MOCK_USER
    let mockViewModel = AuthViewModel()
    mockViewModel.currentUser = mockUser
    
    return ProfileView()
        .environmentObject(mockViewModel)
}
