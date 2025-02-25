//
//  SignInView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

struct SignInView: View {
    @EnvironmentObject var authModel: AuthModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Controls password visibility for both fields
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
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
                    
                    Button {
                        isSecure.toggle()
                    } label: {
                        Image(systemName: isSecure ? "eye.slash" : "eye")
                            .foregroundColor(Color.gray)
                    }
                }
                .padding(.horizontal)
                
                // Login button
                Button {
                    print("Log In tapped with email: '\(email)' and password: '\(password)'")
                    
                    
                    // Logic to process login attempt
                    // Task was causing issues here due to conflicts with my custom Task model. Keep an eye on this if anything goes wrong. Might need to rename my Task to TaskModel or something similar
                    _Concurrency.Task {
                        try await authModel.signIn(withEmail: email, password: password)
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
                
                // Create new account button/link
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Create New Account")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
}

// Ensure that valid information is passed into the authentication form
// MARK - AuthenticationFormProtocol
extension SignInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        // TODO: Implement bool logic for conditions I want the user's submission details to meet
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    SignInView()
}
