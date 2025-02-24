//
//  SignInView.swift
//  MHDungeon
//

// TODO: Chat is kinda bad at design, go through and humanize this

import SwiftUI



struct SignInView: View {
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
                Button  {
                    // TODO: Implement login logic
                    print("Log In tapped with email: '\(email)' and password: '\(password)'")
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

#Preview {
    SignInView()
}
