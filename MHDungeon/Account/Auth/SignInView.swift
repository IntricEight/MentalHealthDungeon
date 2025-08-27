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
    
    /// Controls password visibility for Password entry fields
    @State private var isSecure: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                Rectangle().fill(Color.blue).frame(height: screenHeight * IMAGE_BORDER)
                
                // The main content of the login page
                VStack(spacing: 20) {
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
                    HStack {
                        Group {
                            if isSecure {
                                SecureField("Password", text: $password)
                                    .disableAutocorrection(true)
                            } else {
                                TextField("Password", text: $password)
                                    .disableAutocorrection(true)
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        
                        // Visibility toggle
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding(.horizontal)
                    
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
    /// Records any issues found with the user's email attempt format.
    var emailStatus: EmailAuthStatus {
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
