//
//  SettingsView.swift
//  MHDungeon
//

import SwiftUI

// TODO: Create a settings page for the user to control features about their account. This will probably be a NavigationStack

/// A view page thats allows users to view and change their account details.
struct SettingsView: View {
    @EnvironmentObject private var authModel: AuthModel
    
    var body: some View {
        // TODO: Current version of the settings was used in a auth lesson to display the user information, allow account deletion, and signing out. Refine it
        
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
                .frame(alignment: .top)
                .fontWeight(.bold)
            
            if let user = authModel.currentAccount {
                Text("\(user.displayName) (\(user.email))")
                    .font(.title)
                    .padding()
                
                Section("Account") {
                    Button {
                        print("Signing out.")
                        
                        authModel.signOut()
                    } label: {
                        Text("Sign out")
                    }
                    .padding(10)
                    
                    Button {
                        print("Deleting account...")
                        
                        // Logic to process deleting an account
                        _Concurrency.Task {
                            await authModel.deleteUser()
                        }
                    } label: {
                        Text("Delete account")
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    SettingsView()
}
