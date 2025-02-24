//
//  AuthModel.swift
//  MHDungeon
//

import Foundation
import FirebaseAuth

// TODO: Refactor the following code to conform to the new @Observable instead of the old ObOb-Pub form
// Don't forget the @StateObject scattered around the authentication process when you do so

//@Observable
class AuthModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    
    
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in attempt with email '\(email)' and password '\(password)'")
    }
    
    func createUser(withEmail email: String, displayName name: String, password: String) async throws {
        print("User creation attempt with email '\(email)', display name '\(name)', and password '\(password)'")
    }
    
    func signOut() {
        print("Sign out attempt registered")
    }
    
    func deleteAccount() {
        print("Account deletion attempt registered")
    }
    
    func fetchUserData() async {
        
    }
    
}
