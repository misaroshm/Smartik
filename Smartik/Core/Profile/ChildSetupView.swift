//
//  ChildSetupView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 25.05.2025.
//


import SwiftUI

struct ChildSetupView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var isEditing: Bool = false
    
    @State private var name = ""
    @State private var age = 5
    @State private var selectedAvatar = "avatar1"
    
    let availableAges = Array(4...8)
    let avatarNames = [
        "avatar1", "avatar2", "avatar3", "avatar4", "avatar5",
        "avatar6", "avatar7", "avatar8", "avatar9", "avatar10"
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Привіт! Як звати дитину?")
                .font(AppFont.comicSansMsBold.font(size: 25))
                .multilineTextAlignment(.center)
            
            TextField("Ім’я дитини", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .font(AppFont.comfortaaBold.font(size: 20))
                .cornerRadius(12)
                .padding(.horizontal)

            Picker("Вік дитини", selection: $age) {
                ForEach(4...12, id: \.self) { age in
                    Text("\(age) років").tag(age)
                        .font(AppFont.comfortaaBold.font(size: 20))
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            
            
            Text("Обери аватар:")
                .font(AppFont.comicSansMsBold.font(size: 25))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(avatarNames, id: \.self) { avatar in
                        Image(avatar)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(selectedAvatar == avatar ? Color.blue : Color.clear, lineWidth: 3)
                            )
                            .shadow(radius: selectedAvatar == avatar ? 4 : 0)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedAvatar = avatar
                                }
                            }
                    }
                }
                .padding(.vertical)
            }
            
            Button(action: {
                Task {
                    await viewModel.updateChildProfile(name: name, age: age, avatar: selectedAvatar)
                    await MainActor.run {
                        if isEditing {
                            dismiss()
                        } else {
                            viewModel.appState = .main
                        }
                    }
                }
            }){
                Text("Зберегти")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color(hex: "#EF3349"))
                    .font(AppFont.comfortaaBold.font(size: 20))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .disabled(name.isEmpty)
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            if let user = viewModel.currentUser {
                self.name = user.childName ?? ""
                self.age = user.childAge ?? 5
                self.selectedAvatar = user.avatarName ?? "avatar1"
            }
        }
    }
}

#Preview {
    let mockViewModel = AuthViewModel()
    mockViewModel.currentUser = User.MOCK_USER
    mockViewModel.userSession = nil
    
    return ChildSetupView()
        .environmentObject(mockViewModel)
}

