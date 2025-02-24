//
//  RegistrationView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

struct RegistrationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authModel: AuthModel
    
    // Gather the user's sign up information
    @State private var email: String = ""
    @State private var customName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // Controls password visibility for both fields
    @State private var isSecure: Bool = true

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
            
            // Password input field
            HStack {
                if isSecure {
                    SecureField("Password", text: $password)
                } else {
                    TextField("Password", text: $password)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            // Confirm password input field
            HStack {
                if isSecure {
                    SecureField("Confirm Password", text: $confirmPassword)
                } else {
                    TextField("Confirm Password", text: $confirmPassword)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            // Toggle button for password visibility (applies to both fields)
            Button(action: {
                isSecure.toggle()
            }) {
                HStack {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                    Text(isSecure ? "Show Passwords" : "Hide Passwords")
                }
                .foregroundColor(.blue)
            }
            
            // Create Account button
            Button(action: {
                print("Create Account tapped with email: '\(email)' and password: '\(password)'")
                
                // Logic to process account creation attempt
                _Concurrency.Task {
                    try await authModel.createUser(withEmail: email, displayName: customName, password: password)
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
            
            Button {
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

#Preview {
    RegistrationView()
}
