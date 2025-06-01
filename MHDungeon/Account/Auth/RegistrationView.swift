//
//  RegistrationView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

/// A view page that allows the user to register a new account in the application.
///
/// - Note: Intended to be used as a part of a `NavigationStack`
struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authModel: AuthModel
    
    // Gather the user's sign up information
    /// The user's unique email.
    @State private var email: String = ""
    /// The name that the user will be identified by.
    @State private var customName: String = ""
    /// The user's desired password.
    @State private var password: String = ""
    /// A repeat of the user's desired password for verification purposes.
    @State private var confirmPassword: String = ""
    
    /// Controls password visibility for the first Password entry field
    @State private var isSecure: Bool = true
    /// Controls password visibility for the Confirm Password entry field
    @State private var isSecureConfirm: Bool = true

    var body: some View {
        
        VStack(spacing: 20) {
            // Title for the create account view
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Email input field
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            
            // Display name input field
            TextField("Display name", text: $customName)
                .autocapitalization(.words)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Password input field with visibility toggle
            HStack {
                Group {
                    if isSecure {
                        SecureField("Password", text: $password)
                    } else {
                        TextField("Password", text: $password)
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
            
            // Confirm Password input field with visibility toggle
            HStack {
                Group {
                    if isSecureConfirm {
                        SecureField("Confirm Password", text: $confirmPassword)
                    } else {
                        TextField("Confirm Password", text: $confirmPassword)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                
                // Visibility toggle
                Button {
                    isSecureConfirm.toggle()
                } label: {
                    Image(systemName: isSecureConfirm ? "eye.slash" : "eye")
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.horizontal)
            
            // Create Account button
            Button(action: {
                print("Create Account tapped with email: '\(email)' and password: '\(password)'")
                
                // Logic to process account creation attempt
                _Concurrency.Task {
                    try await authModel.CreateUser(withEmail: email, displayName: customName, password: password)
                }
                
            }) {
                Text("Create Account")
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
            
            Button {
                // Move down the NavigationStack
                dismiss()
            } label: {
                Text("Sign in with an existing account")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
//            Spacer()
        }
        .padding()
        .navigationBarTitle("Create Account", displayMode: .inline)
    }
}

// Ensure that valid information is passed into the authentication form
// MARK - AuthenticationFormProtocol
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        // TODO: Implement bool logic for conditions I want the user's submission details to meet
        return !email.isEmpty && email.contains("@") && !customName.isEmpty && !password.isEmpty && password.count > 5 && password == confirmPassword
    }
}

#Preview {
    RegistrationView()
}
