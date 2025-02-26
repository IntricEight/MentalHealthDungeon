//
//  AuthModel.swift
//  MHDungeon
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// TODO: Make sure that authentication protocols around the app Regex to make sure emails are in proper format
// Ensure that proper conditions are met before a form can be submitted
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

// TODO: Refactor the following code to conform to the new @Observable instead of the old ObOb-Pub form. Push to GitHub before doing so.
// Don't forget the @StateObject scattered around the authentication process when you do so

//@Observable
@MainActor
class AuthModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentAccount: Account?
    
    init() {
        // Save the user's login state between app uses
        self.userSession = Auth.auth().currentUser
        
        // Get the current user's account details from Firestore
        _Concurrency.Task {
            await fetchUser()
        }
    }
    
    
    
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in attempt with email '\(email)' and password '\(password)'")
        
        do {
            // Send the auth request to Firebase and save the successful response
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Store the authenticated user and create for them an Account instance to record their data
            self.userSession = authResult.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    // Create a user through Firebase using their email, a password, and a chosen account display name
    func createUser(withEmail email: String, displayName name: String, password: String) async throws {
        print("User creation attempt with email '\(email)', display name '\(name)', and password '\(password)'")
        
        do {
            // Send the auth request to Firebase and save the successful response
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Store the authenticated user and create for them an Account instance to record their data
            self.userSession = authResult.user
            let account = Account(id: authResult.user.uid, displayName: name, email: email)
            
            // Encode the current user account and upload it to the Firestore "users" collection
            let encodedAccount = try Firestore.Encoder().encode(account)
            try await Firestore.firestore().collection("users").document(account.id).setData(encodedAccount)
            
            // Fetch the data back from firebase to store in an account
            await fetchUser()
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        print("Sign out attempt registered")
        
        do {
            // Sign out of the Firebase backend
            try Auth.auth().signOut()
            
            // Sign out of the local user session and removes its traces
            // TODO: I'm worried that this could cause some memory leaks. Double check on this later
            self.userSession = nil
            self.currentAccount = nil
            
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteUser() async {
        print("Account deletion attempt registered")
        
        do {
            // Retrieve the user's UID from the local auth state
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            // Delete the account of the user currently logged in (And its record from the "users" database)
            try await Firestore.firestore().collection("users").document(uid).delete()
            try await Auth.auth().currentUser?.delete()
            
            // Sign out of the local user session and removes its traces
            // TODO: I'm worried that this could cause some memory leaks. Double check on this later (Copy of signOut's TODO)
            await MainActor.run {
                self.userSession = nil
                self.currentAccount = nil
            }
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Retrieve the user's account data from the "users" collection
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
            return
        }
        
        // Store the snapshot of the user's data in the local account
        self.currentAccount = try? snapshot.data(as: Account.self)
        
        print("Retrieved data of user \(self.currentAccount)")
    }
     
}
