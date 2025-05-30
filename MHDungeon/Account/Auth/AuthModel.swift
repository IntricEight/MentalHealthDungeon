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
            await fetchUser()
        }
    }
    
    /// Attempt to sign the user into `Firebase` using the Email/Password sign-in method.
    /// - Parameters:
    ///   - email: The user's unique email address.
    ///   - password: The user's password.
    func SignIn(withEmail email: String, password: String) async throws {
        print("Sign in attempt with email '\(email)' and password '\(password)'")
        
        do {
            // Send the auth request to Firebase and save the successful response
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Store the authenticated user
            self.userSession = authResult.user
            
            // Create for the user an Account instance to record their data
            await fetchUser()
        } catch {
            // The sign in process failed
            // TODO: Eventually, pass this error up so the view can handle it
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    /// Create a user through `Firebase`.
    ///
    /// The account will be created using the user-provided provided email, password, and chosen account display name
    /// - Note: Data-validity checking does not occur in this function.
    /// - Parameters:
    ///   - email: The user's unique email address, which they already own elsewhere.
    ///   - name: The user's desired visual name on the application.
    ///   - password: The user's desired password.
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
    
    /// Sign out of the current `Firebase` session and remove their data from the local storage.
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
    
    /// Delete the current user from the `Firebase` `Firestore` database, and remove their data from the local storage.
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
    
    /// Retrieve the current user's `Account` data from `Firestore` and store it in a local instance inside `currentAccount`
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
        
//        print("Retrieved data of user \(self.currentAccount)")
    }
    
    // TODO: Bring the task creation into another function? Not sure if that would be good practice or not
    /// Add a new `Task` to the user's `Firestore` storage and the local `Account` instance
    func addTask(name: String, details: String, points: Int, hours: Double) throws {
        // Attempt to create the new task and get its ID
        var newTask: Task = try Task(name: name, details: details, inspirationPoints: points, hoursToExpiration: hours)
        let taskUID: UUID = newTask.id
        
        print("Adding Task UUID: \(taskUID)).")
        
        // Check that an accounr is currently registered. Passed by reference, so changes to account affect currentAccount
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Add a task to the user's account
        account.taskList.append(newTask)
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Convert the taskList into a dictionary to allow it to be used in updating the database record
        let updatedTaskList = account.taskList.map{ $0.toDictionary() }
    
        // Add the task to the database
        Firestore.firestore().collection("users").document(uid).updateData(["taskList": updatedTaskList ])
    }
    
    /// Remove a `Task` from the user's local `Account` instance and the `Firestore`
    func deleteTask(id taskUID: UUID?, isCompleted: Bool) {
        print("Removing Task UUID: \(String(describing: taskUID)).")
        
        // Check that an accounr is currently registered. Passed by reference, so changes to account affect currentAccount
        guard let account = currentAccount else {
            print("Stored account value is nil")
            return
        }
        
        // Implement removal of specified task from user's account
        guard let index = account.taskList.firstIndex(where: {
            $0.id == taskUID
        }) else {
            print("No Task with UID \(String(describing: taskUID)) found")
            return
        }
        
        // Retrieve the user's UID from the local auth state
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Reward the user if the task was completed
        if isCompleted {
            // Reward the user for completing the task
            account.RewardPoints(index: index)
            
            // Increase the user's total number of completed tasks
            account.IncreaseTaskCompletions()
        }
        
        // Remove the task from the user's account
        // TODO: Set a timer on the task category to prevent quickly-repeated use
        account.taskList.remove(at: index)
        
        // Convert the taskList into a dictionary to allow it to be used in updating the database record
        let updatedTaskList = account.taskList.map{ $0.toDictionary() }
    
        // Remove the task from the database, and update the user's inspiration points
        Firestore.firestore().collection("users").document(uid).updateData(["taskList": updatedTaskList, "inspirationPoints": account.inspirationPoints ])
        
//        print("Task at index \(index) with UID \(String(describing: taskUID)) removed from database. Please confirm in Firebase")
    }
    
    
    // TODO: Either update the name of the function or update the features to include more details about the user
    /// Update the user's information in the `Firestore` entry
    func updateUser(displayName name: String) {
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
    
    
    func updatePoints(inspirationPoints points: Int) {
        
        
        
        print("Changed IP record from ")
    }
}
