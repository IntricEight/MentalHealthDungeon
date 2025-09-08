//
//  AuthModel.swift
//  MHDungeon
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// TODO: Make sure that authentication protocols around the app use Regex to make sure emails are in proper format
/// Utilized by extensions on `Views` to ensure that proper conditions are met before allowing an authentication form to be submitted.
protocol AuthenticationFormProtocol {
    var emailStatus: EmailAuthStatus { get }
    var passwordStatus: PasswordAuthStatus { get }
    
    /// Checks and records whether the current form has met the conditions to be submitted.
    var formIsValid: Bool { get }
}

/// A model which manages the authorization process with `FirebaseAuth`, and any functions that require accessing `Firebase` and its `Firestore`.
@MainActor
class AuthModel: ObservableObject {
    /// The current `Firebase` user, retrieved through `FirebaseAuth`
    @Published var userSession: FirebaseAuth.User?
    
    /// The account of the current user.
    ///
    /// Contains app-specific details about the user, such as their display name or current inpsiration points.
    @Published var currentAccount: Account?
    
    /// Initialize an instance of the authorization model.
    ///
    /// Stores the current `Firebase` user in a local session variable. Only one instance of `AuthModel` should exist at a time.
    init() {
        // Save the user's login state between app uses
        self.userSession = Auth.auth().currentUser
        
        // Get the current user's account details from Firestore
        _Concurrency.Task {
            await FetchUser()
        }
    }
    
    /// Attempt to sign the user into `Firebase` using the Email/Password sign-in method.
    /// - Parameters:
    ///   - email: The user's unique email address.
    ///   - password: The user's password.
    func SignIn(withEmail email: String, password: String) async throws {
        print("Sign in attempt with email '\(email)' and password '\(password)'")
        
        // Send the auth request to Firebase and save the successful response
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        // Store the authenticated user
        self.userSession = authResult.user
        
        // Create for the user an Account instance to record their data
        await FetchUser()
    }
    
    /// Create a user through `Firebase`.
    ///
    /// The account will be created using the user-provided provided email, password, and chosen account display name
    /// - Note: Data-validity checking does not occur in this function.
    /// - Parameters:
    ///   - email: The user's unique email address, which they already own elsewhere.
    ///   - name: The user's desired visual name on the application.
    ///   - password: The user's desired password.
    func CreateUser(withEmail email: String, displayName: String, password: String) async throws {
        print("User creation attempt with email '\(email)', display name '\(displayName)', and password '\(password)'")
        
        do {
            // If the user has not provided a display name, use the name from the email
            var name: String
            if displayName.isEmpty {
                name = ( email.components(separatedBy: "@") )[0]
            } else {
                name = displayName
            }
            
            // Send the auth request to Firebase and save the successful response
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Store the authenticated user and create for them an Account instance to record their data
            self.userSession = authResult.user
            let account = Account(id: authResult.user.uid, displayName: name, email: email)
            
            // Encode the current user account and upload it to the Firestore "users" collection
            let encodedAccount = try Firestore.Encoder().encode(account)
            try await Firestore.firestore().collection("users").document(account.id).setData(encodedAccount)
            
            // Fetch the data back from firebase to store in an account
            await FetchUser()
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    /// Sign out of the current `Firebase` session and remove their data from the local storage.
    func SignOut() {
        print("Sign out attempt registered")
        
        do {
            // Sign out of the Firebase backend
            try Auth.auth().signOut()
            
            // Sign out of the local user session and removes its traces
            self.userSession = nil
            self.currentAccount = nil
            
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    /// Delete the current user from the `Firebase` `Firestore` database, and remove their data from the local storage.
    func DeleteUser() async {
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
            await MainActor.run {
                self.userSession = nil
                self.currentAccount = nil
            }
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    /// Retrieve the current user's `Account` data from `Firestore` and store it in a local instance inside `currentAccount`.
    func FetchUser() async {
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
    }
    
    /// Add a new `Task` to the user's `Firestore` storage and the local `Account` instance.
    ///
    /// - Parameters:
    ///   - name: The name of the `Task`.
    ///   - details: An explanation of the `Task`. This can include notes, instructions, or anything else the user wants to record about the task.
    ///   - points: The numbers of `Inspiration Points` that completing the `Task` will reward.
    ///   - hoursToExpiration: The hours until the `Task` expires and cannot be completed.
    func AddTask(name: String, details: String, points: Int, hours: Double) throws {
        // Check that an accounr is currently registered. Passed by reference, so changes to account affect currentAccount
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create a new task inside the account and store its id
        let taskUID: UUID = try account.AddTask(name: name, details: details, inspirationPoints: points, hours: hours)
        print("Adding Task UUID: \(taskUID)).")
        
        // Convert the taskList into a dictionary to allow it to be used in updating the database record
        let updatedTaskList = account.taskList.map{ $0.toDictionary() }
    
        // Add the task to the database
        Firestore.firestore().collection("users").document(uid).updateData(["taskList": updatedTaskList ])
    }
    
    /// Remove a `Task` from the user's local `Account` instance and the `Firestore`.
    ///
    /// - Parameters:
    ///   - taskUID: The unique ID of the target `Task`.
    ///   - isCompleted: Whether the Task `was` removed before or after its expiration time.
    func DeleteTask(id taskUID: UUID?, isCompleted: Bool) {
        print("Removing Task UUID: \(String(describing: taskUID)).")
        
        // Check that an accounr is currently registered. Passed by reference, so changes to account affect currentAccount
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Remove the Task from the user's account using its UUID
        account.RemoveTask(id: taskUID, isCompleted: isCompleted)
        
        // Convert the taskList into a dictionary to allow it to be used in updating the database record
        let updatedTaskList = account.taskList.map{ $0.toDictionary() }
    
        // Remove the task from the database, and update the user's inspiration points
        Firestore.firestore().collection("users").document(uid).updateData(["taskList": updatedTaskList, "inspirationPoints": account.inspirationPoints, "tasksCompleted": account.tasksCompleted ])
    }
    
    /// Update the user's information in the `Firestore` entry.
    ///
    /// - Parameters:
    ///   - name: The user's chosen display name.
    func UpdateUser(displayName name: String) {
        /// The name that used to be associated with the current user's account
        let oldName: String = currentAccount?.displayName ?? "No old name found"
        
        // Leave the function if nothing new has actually been added
        if name == oldName {
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Update the user's Display Name in the database
        Firestore.firestore().collection("users").document(uid).updateData(["displayName": name ]) { error in
            if let error = error {
                print("Error updating display name: \(error.localizedDescription)")
            } else {
                print("Display name updated successfully!")
            }
        }
        
        print("Changed user display name from \"\(oldName)\" to \"\(name)\"")
    }
    
    /// Begin an adventure inside a `Dungeon` on the user's `Account`.
    ///
    /// - Parameters:
    ///   - name: The `String` name of the `Dungeon` that the adventure will be in.
    func BeginAdventure(dungeonName name: String) throws {
        // Check that an accounr is currently registered, and grab it if so
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Start the dungeon timer through the account
        try account.BeginAdventure(dungeonName: name)
        
        // Save the timer's state within Firebase alongside the point reduction and dungeon's name
        Firestore.firestore().collection("users").document(uid).updateData(["inspirationPoints": account.inspirationPoints,  "activeDungeonName": account.activeDungeonName, "dungeonEndTime": account.dungeonEndTime ])
        
        print("Beginning adventure in Auth Model")
    }
    
    /// Mark an active adventure as complete and reward the user accordingly.
    ///
    /// - Parameters:
    ///   - name: The `String` name of the `Dungeon` that the adventure was in.
    func CompleteAdventure(dungeonName name: String) {
        // Get the dungeon that the adventure took place in
        let activeDungeon = try! Dungeon(name: name)
        
        // Check that an accounr is currently registered, and grab it if so
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Mark the dungeon as complete through the user's account
        account.CompleteAdventure(dungeon: activeDungeon)
        
        // Update the database with the now-empty active dungeon name
        Firestore.firestore().collection("users").document(uid).updateData(["activeDungeonName": account.activeDungeonName, "dungeonsCompleted": account.dungeonsCompleted ])
        
        print("Completed the dungeon in the Auth Model!")
    }
    
    
    
}
