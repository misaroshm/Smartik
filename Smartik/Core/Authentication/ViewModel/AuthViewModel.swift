//
//  AuthViewModel.swift
//  Smartik
//
//  Created by Mariia Misarosh on 12.05.2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var appState: AppState = .onboarding
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    
    init() {
        self.appState = .splash
        self.userSession = Auth.auth().currentUser
        self.isLoading = true
        checkUser()
        
        Task {
            await loadUserSession()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            self.userSession = result.user
            await fetchUser()
        } catch {
            let nsError = error as NSError
            print("DEBUG: Firebase signIn error: \(error.localizedDescription), code: \(nsError.code)")
            throw error
        }
    }
    
    
    @MainActor
    func loadUserSession() async {
        if let user = Auth.auth().currentUser {
            self.userSession = user
            await fetchUser()
            
            if let name = currentUser?.childName, !name.isEmpty {
                self.appState = .main
            } else {
                self.appState = .onboarding
            }
        } else {
            self.appState = .auth
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, email: email, fullname: fullname)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.appState = .onboarding
            }
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    
    func checkUser() {
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            if let user = Auth.auth().currentUser {
                self.userSession = user
                await fetchUser()
            } else {
                self.appState = .auth
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            self.userSession = nil
            self.currentUser = nil
            
            self.appState = .auth //делітнуть
            
        } catch {
            print("DEBUG: Failed to sign out with errpr: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        do {
            try await Auth.auth().currentUser?.delete()
            deleteUserData()
            self.currentUser = nil
            self.userSession = nil
            
            self.appState = .auth
        } catch {
            print("DEBUG: Failed to delete account with error \(error.localizedDescription)")
        }
    }
    
    
    func deleteUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).delete()
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            if let user = try? snapshot.data(as: User.self) {
                DispatchQueue.main.async {
                    self.currentUser = user
                    self.userSession = Auth.auth().currentUser
                    
                    if user.childName == nil || user.childAge == nil || user.avatarName == nil {
                        self.appState = .onboarding
                    } else {
                        self.appState = .main
                    }
                }
            } else {
                self.appState = .auth
            }
        } catch {
            print("DEBUG: Error fetching user: \(error.localizedDescription)")
            self.appState = .auth
        }
    }
    
    func firebaseErrorMessage(from error: Error) -> String {
        let nsError = error as NSError
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return "Сталася помилка. Перевірте дані та спробуйте ще раз."
        }
        
        switch errorCode {
        case .invalidEmail:
            return "Невірна електронна адреса."
        case .wrongPassword:
            return "Невірний пароль. Спробуйте ще раз."
        case .userNotFound:
            return "Користувача з такою адресою не знайдено."
        case .emailAlreadyInUse:
            return "Ця електронна адреса вже використовується."
        case .weakPassword:
            return "Пароль надто слабкий. Використовуйте щонайменше 6 символів."
        case .userDisabled:
            return "Цей акаунт було вимкнено. Зверніться до підтримки."
        case .tooManyRequests:
            return "Забагато спроб. Спробуйте пізніше."
        case .operationNotAllowed:
            return "Вхід через email і пароль наразі вимкнений."
        case .invalidCredential:
            return "Невірний email або пароль. Спробуйте ще раз."
        default:
            return "Сталася помилка. Перевірте дані та спробуйте ще раз."
        }
    }
    
    func updateChildProfile(name: String, age: Int, avatar: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "childName": name,
            "childAge": age,
            "avatarName": avatar
        ]
        
        do {
            try await Firestore.firestore().collection("users").document(uid).updateData(data)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to update child profile: \(error.localizedDescription)")
        }
    }
    
    static func updateParentInfo(fullName: String, email: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        Task {
            do {
                guard let user = Auth.auth().currentUser else {
                    completion(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Користувач не знайдений"]))
                    return
                }
                
                try await user.sendEmailVerification(beforeUpdatingEmail: email)
                
                if !newPassword.isEmpty {
                    try await user.updatePassword(to: newPassword)
                }
                
                let uid = user.uid
                try await Firestore.firestore().collection("users").document(uid).updateData([
                    "fullname": fullName,
                    "email": email
                ])
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func sendPasswordReset(to email: String, completion: @escaping (Error?) -> Void) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://smartik-e3d54.firebaseapp.com/__/auth/action")!
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID("com.mariiamisarosh.Smartik")
        
        Auth.auth().sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
            completion(error)
        }
    }
    
    @MainActor
    func startApp() async {
        print("старт додатку")
        do {
            if let user = Auth.auth().currentUser {
                print("знайдено користувача")
                self.userSession = user
                await fetchUser()
                
                if let name = currentUser?.childName, !name.isEmpty {
                    self.appState = .main
                } else {
                    self.appState = .onboarding
                }
            } else {
                print("користувача немає")
                self.appState = .auth
            }
        } catch {
            print("DEBUG: Failed to start: \(error.localizedDescription)")
            self.appState = .auth
        }
    }
    
    @MainActor
    func reauthenticateAndDeleteAccount(password: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            try await user.reauthenticate(with: credential)
            try await user.delete()
            deleteUserData()
            self.currentUser = nil
            self.userSession = nil
            self.appState = .auth
        } catch {
            throw error
        }
    }


   
}
