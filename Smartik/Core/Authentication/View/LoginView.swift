//
//  LoginView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var loginErrorMessage: String? = nil
    @State private var showResetAlert = false
    @State private var resetEmailSent = false
    @State private var resetError: String? = nil
    
    @State private var isLoading = false
    @State private var animateLogo = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Логотип + заголовок
                VStack(spacing: 12) {
                    Image("logo_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .scaleEffect(animateLogo ? 1.0 : 0.5)
                        .opacity(animateLogo ? 1 : 0)
                        .animation(.easeOut(duration: 0.8), value: animateLogo)
                        .onAppear {
                            animateLogo = true
                        }
                    
                    Text("Вхід в акаунт")
                        .font(AppFont.comicSansMsBold.font(size: 36))
                    
                        .foregroundColor(Color(red: 0, green: 0.36, blue: 0.31))
                }
                .padding(.bottom, 24)
                
                // Форма
                VStack(spacing: 20) {
                    InputView(
                        text: $email,
                        title: "Електронна адреса",
                        placeholder: "name@example.com",
                        iconName: "envelope"
                    )
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    
                    InputView(
                        text: $password,
                        title: "Пароль",
                        placeholder: "Введіть пароль",
                        isSecureField: true,
                        iconName: "lock"
                    )
                    
                    if let loginErrorMessage = loginErrorMessage {
                        Text(loginErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                            .transition(.opacity)
                    }
                    
                    HStack {
                        Spacer()
                        Button("Забули пароль?") {
                            handlePasswordReset()
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }
                    .padding(.trailing, 4)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Кнопка входу
                Button {
                    isLoading = true
                    Task {
                        await handleLogin()
                        isLoading = false
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    } else {
                        HStack {
                            Text("Увійти")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                }
                .background(Color(red: 0, green: 0.36, blue: 0.31))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(30)
                .padding(.top)
                
                
                Spacer()
                
                // Кнопка переходу до реєстрації
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Не маєте акаунта?")
                        Text("Зареєструватися")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
            
            // перехід до скидання
            .alert("Відновлення пароля", isPresented: $showResetAlert) {
                Button("ОК", role: .cancel) { }
            } message: {
                if resetEmailSent {
                    Text("Лист для відновлення пароля відправлено на \(email).")
                } else if let error = resetError {
                    Text(error)
                } else {
                    Text("Щось пішло не так.")
                }
            }
            Spacer()
        }
        .hideKeyboardOnTap()
    }
    
    
    private func handlePasswordReset() {
        if email.isEmpty || !email.contains("@") {
            resetError = "Введіть правильну email адресу"
            resetEmailSent = false
            showResetAlert = true
        } else {
            Task {
                do {
                    try await viewModel.resetPassword(email: email)
                    resetEmailSent = true
                    resetError = nil
                } catch {
                    resetEmailSent = false
                    resetError = viewModel.firebaseErrorMessage(from: error)
                }
                showResetAlert = true
            }
        }
    }
    
    private func handleLogin() async {
        do {
            try await viewModel.signIn(withEmail: email, password: password)
            loginErrorMessage = nil
        } catch {
            withAnimation {
                loginErrorMessage = "Неправильний email або пароль"
            }
        }
    }
    
}




//MARK: - AuthenticationFormProtocol
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 6
    }
}


#Preview {
    LoginView()
}
