//
//  SettingsView.swift
//  MHDungeon
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var body: some View {
        
        // Interesting note from tutorial, I can't actually use the preview for this file because of the EnvObj. Not sure why, and the actual running process works fine, so I won't pursue it for now. But I should look into this later.
        
        // TODO: May have to change displayName from 'let' to 'var' later
//        let displayName: String = authModel.currentAccount?.displayName ?? "<NAME ERROR>"
//        let email: String = authModel.currentAccount?.email ?? "<EMAIL ERROR>"
        
        // TODO: Create a settings page for the user to control features about their account. This will probably be a .screen?
        
        // TODO: Current version of the settings was used in a auth lesson to display the user information, allow account deletion, and signing out. Refine it later
        
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
