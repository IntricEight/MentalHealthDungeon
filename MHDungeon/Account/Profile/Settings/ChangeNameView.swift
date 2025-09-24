//
//  ChangeNameView.swift
//  MHDungeon
//

import SwiftUI

struct ChangeNameView: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    /// The user's new desired name.
    @State private var newDisplayName: String = ""
    
    var body: some View {
        VStack (spacing: 20) {
            // Title for the change password view
            Text("Enter your New\nDisplay Name below:")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            // Display name input field
            TextField("Display name", text: $newDisplayName)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: newDisplayName) {
                    if newDisplayName.count > MAX_DISPLAY_NAME_LENGTH {
                        newDisplayName = String(newDisplayName.prefix(MAX_DISPLAY_NAME_LENGTH))
                    }
                }
            
            Spacer()
            
            // Button to initiate the password change
            Button {
                // Update the display name
                authModel.UpdateDisplayName(newDisplayName)
                
                // Return to the Settings page
                dismiss()
            } label: {
                Text("Update the Display Name")
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

// Ensure that valid information is passed into the authentication form
extension ChangeNameView: AuthenticationFormProtocol {
    /// Records any issues found with the user's email attempt format.
    var emailStatus: EmailAuthStatus {
        return .None
    }
    
    /// Records any issues found with the user's display name attempt format.
    var displayNameStatus: DisplayNameAuthStatus { authModel.AuthenticateDisplayName(newDisplayName) }
    
    /// Records any issues found with the user's password attempt format.
    var passwordStatus: PasswordAuthStatus {
        return .None
    }
    
    /// Checks if the user has satisfied the conditions to attempt to sign in.
    var formIsValid: Bool {
        return !newDisplayName.isEmpty && displayNameStatus == DisplayNameAuthStatus.None
    }
}

#Preview {
    ChangeNameView()
}
