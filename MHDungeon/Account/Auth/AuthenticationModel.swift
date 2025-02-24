//
//  AuthenticationModel.swift
//  MHDungeon
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signup
}

@MainActor
@Observable class AuthenticationModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    var isValid: Bool = false
    var flow: AuthenticationFlow = .login
    var authenticationState: AuthenticationState = .unauthenticated
    
    var user: User?
    var errorMessage: String = ""
    var displayName: String = ""
    
    init() {
        registerAuthStateHandle()
        
//        flow.combineLatest(email, password, confirmPassword)
//            .map { flow, email, password, confirmPassword in
//                flow == AuthenticationFlow.login
//                ? !(email.isEmpty || password.isEmpty)
//                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
//            }.assign(to: &isValid)
    }
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandle() {
        if authStateHandle == nil {
            authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.displayName ?? "[No name]"
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signup : .login
        errorMessage = ""
    }
    
//    private func wait() async {
//        do {
//            print("Wait")
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//        } catch {
//            
//        }
//    }
    
    
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
    
}



// TODO: Prepare for this to need changing
extension AuthenticationModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            user = authResult.user
            print("User '\(displayName)' <\(authResult.user.uid)> signed in successfully")
            
            return true
            
        } catch {
            print("ERROR encountered while attempting signin with email and password")
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            user = authResult.user
            print("User '\(displayName)' <\(authResult.user.uid)> created an account successfully")
            
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
        
        return true
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    
}
