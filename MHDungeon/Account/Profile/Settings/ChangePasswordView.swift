//
//  ChangePasswordView.swift
//  MHDungeon
//

import SwiftUI

/// A view page that provides the user with an inferface that they can use to change their account's password.
///
/// Requires the user to reauthenticate their account before they can access the new password input.
struct ChangePasswordView: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    /// The user's new desired password.
    @State private var newPassword: String = ""
    /// The user's confirmation spelling of their new desired password.
    @State private var newConfirmPassword: String = ""
    
    /// Monitor the success of the authentication attempt
    @State private var authSuccessState: Bool = false
    
    var body: some View {
        // Require the user to reauthenticate their account before they can change their password
        if !authSuccessState {
            ReauthenticationForm(reauthSuccess: $authSuccessState)
        } else {
            VStack (spacing: 20) {
                // Title for the change password view
                Text("Enter your New\nPassword below:")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                // Password input field with visibility toggle
                PasswordInput(prompt: "Password", input: $newPassword)
                    .padding(.horizontal)
                
                // Confirm Password input field with visibility toggle
                PasswordInput(prompt: "Confirm Password", input: $newConfirmPassword)
                    .padding(.horizontal)
                
                // Display the status of the password's validity
                Text("\(passwordStatus)")
                    .font(.subheadline)
                    .foregroundColor(Color.red)
                
                Spacer()
                
                // Button to initiate the password change
                Button {
                    // Update the password
                    authModel.UpdatePassword(newPassword)
                    
                    // Return to the Settings page
                    dismiss()
                } label: {
                    Text("Update the Password")
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
            }
            .padding()
        }
    }
}

// Ensure that valid information is passed into the authentication form
extension ChangePasswordView: AuthenticationFormProtocol {
    /// Records any issues found with the user's email attempt format.
    var emailStatus: EmailAuthStatus {
        return .None
    }
    
    // No display name is requested, so this will remain unimplemented on this page
    /// Records any issues found with the user's display name attempt format.
    var displayNameStatus: DisplayNameAuthStatus {
        return .None
    }
    
    /// Records any issue found with the user's password.
    var passwordStatus: PasswordAuthStatus { authModel.AuthenticatePassword(password: newPassword, confirmPassword: newConfirmPassword) }
    
    /// Checks if the user has satisfied the conditions to create their account.
    var formIsValid: Bool {
        // Ensure that there are no issues with the new password before allowing the user to proceed
        return !newPassword.isEmpty && !newConfirmPassword.isEmpty && passwordStatus == PasswordAuthStatus.None
    }
}

#Preview {
    ChangePasswordView()
}
