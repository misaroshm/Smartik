//
//  ParentSettingsView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 28.05.2025.
//

import SwiftUI

struct ParentSettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var isEditing = false
    
    @State private var passwordForDelete = ""
    @State private var showDeleteSheet = false
    @State private var deleteErrorMessage = ""
    @State private var showSuccess = false
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                Form {
                    Section(header: headerView(user: user)) {
                        if isEditing {
                            TextField("Ім’я", text: $fullName)
                            TextField("Email", text: $email)
                            SecureField("Новий пароль", text: $newPassword)
                        } else {
                            HStack {
                                Text("Ім’я")
                                Spacer()
                                Text(user.fullname)
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            HStack {
                                Text("Пароль")
                                Spacer()
                                Text("••••••")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    if isEditing {
                        Section {
                            Button("Зберегти зміни") {
                                saveChanges()
                            }
                            .disabled(fullName.isEmpty || email.isEmpty)
                        }
                    }
                    
                    Section(header: Text("Акаунт")) {
                        Button("Вийти з акаунту", role: .destructive) {
                            Task { viewModel.signOut() }
                        }
                        
                        Button("Видалити акаунт", role: .destructive) {
                            showDeleteSheet = true
                        }
                    }
                }
                .navigationTitle("Налаштування")
                .font(AppFont.comfortaaBold.font(size: 15))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                isEditing.toggle()
                                if isEditing {
                                    fullName = user.fullname
                                    email = user.email
                                }
                            }
                        }) {
                            Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil")
                        }
                    }
                }
                .alert(isPresented: $showSuccess) {
                    Alert(title: Text("Зміни збережено"))
                }
                .alert(isPresented: Binding(
                    get: { !deleteErrorMessage.isEmpty },
                    set: { _ in deleteErrorMessage = "" }
                )) {
                    Alert(
                        title: Text("Помилка"),
                        message: Text(deleteErrorMessage),
                        dismissButton: .default(Text("ОК"))
                    )
                }
                .sheet(isPresented: $showDeleteSheet) {
                    DeleteAccountSheet(password: $passwordForDelete, onDelete: {
                        Task {
                            await deleteAccount()
                        }
                    })
                }
            } else {
                ProgressView("Завантаження...")
                    .task {
                        await viewModel.fetchUser()
                    }
            }
        }
        .background(Color.mainBackground)
    }
    
    @ViewBuilder
    func headerView(user: User) -> some View {
        VStack(spacing: 20) {
            Image(user.avatarName ?? "avatar1")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 5)
            
            Text(user.fullname)
                .font(AppFont.comfortaaBold.font(size: 15))
            
            Text(user.email)
                .font(AppFont.comfortaaBold.font(size: 15))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    func saveChanges() {
        AuthViewModel.updateParentInfo(
            fullName: fullName,
            email: email,
            newPassword: newPassword
        ) { error in
            if let error = error {
                deleteErrorMessage = error.localizedDescription
            } else {
                Task {
                    await viewModel.fetchUser()
                    isEditing = false
                    newPassword = ""
                    showSuccess = true
                }
            }
        }
    }
    
    func deleteAccount() async {
        guard !passwordForDelete.isEmpty else {
            deleteErrorMessage = "Будь ласка, введіть пароль."
            return
        }
        
        do {
            try await viewModel.reauthenticateAndDeleteAccount(password: passwordForDelete)
        } catch {
            deleteErrorMessage = "Не вдалося видалити акаунт: \(error.localizedDescription)"
        }
    }
}

struct DeleteAccountSheet: View {
    @Binding var password: String
    var onDelete: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Введіть пароль для підтвердження")) {
                    SecureField("Пароль", text: $password)
                }
                
                Section {
                    Button("Видалити акаунт", role: .destructive) {
                        onDelete()
                    }
                }
            }
            .navigationTitle("Видалення акаунта")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



#Preview {
    let mockViewModel = AuthViewModel()
    mockViewModel.currentUser = User.MOCK_USER
    mockViewModel.userSession = nil
    
    return ParentSettingsView()
        .environmentObject(mockViewModel)
}

