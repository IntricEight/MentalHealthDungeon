//
//  SignInView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

/// The percentage of the screen that it taken by the border images (Between 0 and 1)
private let IMAGE_BORDER: Double = 0.2

/// A view page that allows the user to log into an existing account to use in the application.
struct SignInView: View {
    @EnvironmentObject private var authModel: AuthModel
    
    // Gather the user's sign up information
    /// The user's unique email.
    @State private var email: String = ""
    /// The user's password.
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                Rectangle().fill(Color.blue).frame(height: screenHeight * IMAGE_BORDER)
                
                // The main content of the login page
                VStack(spacing: 20) {
                    // Credentials section
                    VStack {
                        // Title of the sign in view
                        Text("Welcome back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(alignment: .center)
                        
                        // Email input field
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .padding(.horizontal)
                        
                        // Password input field with visibility toggle
                        PasswordInput(prompt: "Password", input: $password)
                            .padding(.horizontal)
                    }
                    
                    // TODO: Remove before releasing as a proper app, if ever
                    // TODO: Update the listed credentials (if needed) once database modifications are over
                    // A developer-use button to sign in without creating an account
                    Spacer()
                    VStack {
                        Text("Developer's Use Only")
                            .font(.title2)
                            .frame(alignment: .center)
                        
                        Text("Sign in using a premade account")
                            .font(.subheadline)
                            .frame(alignment: .center)
                        
                        Button {
                            // Log the user in using a premade account
                            _Concurrency.Task {
                                // Only pass in the email in a lowercase form, to allow the user to write it however they like
                                try await authModel.SignIn(withEmail: "premade@dev.test", password: "cool!Catz98")
                            }
                        } label: {
                            Text("Use Premade Account")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .frame(width: screenWidth * 0.8)
                    }
                    .padding()
                    .border(Color.orange)
                    
                    Spacer()
                    
                    // Navigation buttons
                    VStack {
                        // Login button
                        Button {
                            print("Log In tapped with email: '\(email)' and password: '\(password)'")
                            
                            // Logic to process login attempt
                            // NOTE - Task was causing issues here due to conflicts with my custom Task model. Keep an eye on this if anything goes wrong. Might need to rename my Task to TaskModel or something similar
                            _Concurrency.Task {
                                // Only pass in the email in a lowercase form, to allow the user to write it however they like
                                try await authModel.SignIn(withEmail: email.lowercased(), password: password)
                            }
                            
                        } label: {
                            Text("Log In")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .frame(width: screenWidth * 0.8)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        
                        // Create new account button
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("Don't have an account? Register!")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 10)
                    }
                    .frame(alignment: .bottom)
                }
                .padding()
                .frame(height: screenHeight * (1 - IMAGE_BORDER * 2) )
                
                Rectangle().fill(Color.blue).frame(height: screenHeight * IMAGE_BORDER)
            }.ignoresSafeArea()
        }
    }
}

// Ensure that valid information is passed into the authentication form
extension SignInView: AuthenticationFormProtocol {
    // This function's authentications will remain rather unimplemented for now, because I don't want sign-in attempts to know the account parameters
    
    /// Records any issues found with the user's email attempt format.
    var emailStatus: EmailAuthStatus {
        return .None
    }
    
    // No display name is requested, so this will remain unimplemented on this page
    /// Records any issues found with the user's display name attempt format.
    var displayNameStatus: DisplayNameAuthStatus {
        return .None
    }
    
    /// Records any issues found with the user's password attempt format.
    var passwordStatus: PasswordAuthStatus {
        return .None
    }
    
    /// Checks if the user has satisfied the conditions to attempt to sign in.
    var formIsValid: Bool {
        // TODO: Implement bool logic for conditions I want the user's submission details to meet
        return !email.isEmpty && email.contains("@") && !password.isEmpty
    }
}

#Preview {
    SignInView()
}
