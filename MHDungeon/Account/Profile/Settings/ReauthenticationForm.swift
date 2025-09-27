//
//  ReauthenticationForm.swift
//  MHDungeon
//

import SwiftUI

struct ReauthenticationForm: View {
    @EnvironmentObject private var authModel: AuthModel
    
    /// The user's new desired password.
    @State private var password: String = ""
    @State private var reauthMessage: String = ""
    
    /// Monitor the success of the authentication attempt
    @Binding var reauthSuccess: Bool
    
    var body: some View {
        VStack (spacing: 20) {
            // Title for the change password view
            Text("Confirm your existing password before proceeding:")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            // Password input field with visibility toggle
            PasswordInput(prompt: "Password", input: $password)
                .padding(.horizontal)
            
            Text("\(reauthMessage)")
                .font(.subheadline)
                .foregroundColor(reauthSuccess ? Color.green : Color.red)
            
            Spacer()
            
            // Button to authenticate the user's info
            Button {
                // Reauthenticate the user
                authModel.ReauthenticateUser(password: password) { success in
                    if success {
                        reauthMessage = "Authentication succeeded, please wait for the page to load."
                    } else {
                        reauthMessage = "Failed to authenticate, please try again."
                    }
                    
                    reauthSuccess = success
                }
                
                print("Finished attempt to reauthenticate the user")
            } label: {
                Text("Authenticate")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .frame(width: screenWidth * 0.8)
            .disabled(password.isEmpty)
            .opacity(password.isEmpty ? 0.5 : 1.0)
        }
        .padding()
    }
}
