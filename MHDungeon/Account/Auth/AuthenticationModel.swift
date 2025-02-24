//
//  AuthenticationModel.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/23/25.
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
    
    init() {}
    
}




extension AuthenticationModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            user = authResult.user
            displayName = user?.displayName ?? "[No name]"
            
            print("User '\(displayName)' <\(authResult.user.uid)> signed in successfully")
            
            authenticationState = .authenticated
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
        
        
        return true
    }
    
    func signOut() {
        authenticationState = .unauthenticated
        
        
    }
    
    func deleteAccount() async -> Bool {
        authenticationState = .unauthenticated
        
        
        return true
    }
    
    
}
