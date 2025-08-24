//
//  SignInView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

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
            
            VStack(spacing: 20) {
                
                // Title of the sign in view
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
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
                            try await authModel.SignIn(withEmail: email, password: password)
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
                        Text("Create New Account")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }.frame(alignment: .bottom)
            }
            .padding()
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
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    SignInView()
}
