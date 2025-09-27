//
//  DeleteAccountView.swift
//  MHDungeon
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    /// Monitor the success of the authentication attempt.
    @State private var authSuccessState: Bool = false
    /// Track whether the user really does want to delete their account.
    @State private var confirmIntent: Bool = false
    
    var body: some View {
        // Require the user to reauthenticate their account before they can delete their account
        if !authSuccessState {
            ReauthenticationForm(reauthSuccess: $authSuccessState)
        } else {
            VStack (spacing: 20) {
                Text(confirmIntent
                     ? "Press again to delete your account"
                     : "Are you sure you want to delete your account?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                Text("This action is irreversible")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                // Require the user to confirm their intent of deleting their account before allowing them to proceed
                Button {
                    // Check if the user has confirmed that they want to delete their account
                    if confirmIntent {
                        print("Deleting account...")

                        // Process deleting an account
                        _Concurrency.Task {
                            await authModel.DeleteUser()
                        }
                    } else {
                        // Record that they have confirmed their intent
                        confirmIntent = true
                    }
                } label: {
                    Text(confirmIntent
                         ? "Delete Account"
                         : "I am sure")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .frame(width: screenWidth * 0.8)
            }
        }
    }
}

#Preview {
    DeleteAccountView()
}
