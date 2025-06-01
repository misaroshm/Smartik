//
//  RegistrationView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var isLoading = false
    @State private var animateLogo = false
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
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
                    
                    
                    Text("Створіть акаунт")
                        .font(AppFont.comicSansMsBold.font(size: 36))
                    
                        .foregroundColor(Color(red: 0, green: 0.36, blue: 0.31))
                }
                .padding(.bottom, 24)
                
                
                //form fields
                VStack(spacing: 20) {
                    InputView(text: $email,
                              title: "Електронна адреса",
                              placeholder: "name@example.com",
                              iconName: "envelope")
                    .autocapitalization(.none)
                    
                    InputView(text: $fullname,
                              title: "Імʼя та прізвище",
                              placeholder: "Введіть імʼя та прізвище",
                              iconName: "person")
                    
                    InputView(text: $password,
                              title: "Парооль",
                              placeholder: "Введіть пароль",
                              isSecureField: true,
                              iconName: "lock")
                    
                    InputView(
                        text: $confirmPassword,
                        title: "Підтвердження паролю",
                        placeholder: "Підтвердіть пароль",
                        isSecureField: true,
                        iconName: "lock.rotation",
                        trailingIcon: {
                            Group {
                                if !password.isEmpty && !confirmPassword.isEmpty {
                                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                } else {
                                    EmptyView()
                                }
                            }
                        }
                    )
                    
                    //button
                    Button {
                        isLoading = true
                        Task {
                            try await viewModel.createUser(withEmail: email,
                                                           password: password,
                                                           fullname: fullname)
                            isLoading = false
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        } else {
                            HStack {
                                Text("Зареєструватися")
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
                }
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                
                // перехід до логіну
                NavigationLink {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Вже маєте акаунт?")
                        Text("Увійти")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
        .hideKeyboardOnTap()
    }
}


//MARK: - AuthenticationFormProtocol
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 6
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

#Preview {
    RegistrationView()
}
