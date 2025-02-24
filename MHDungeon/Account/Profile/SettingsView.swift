//
//  SettingsView.swift
//  MHDungeon
//

import SwiftUI

struct SettingsView: View {
    var displayName: String = Account.MOCK_USER.displayName
    var email: String = Account.MOCK_USER.email
    
    
    var body: some View {
        // TODO: Create a settings page for the user to control features about their account. This will probably be a .screen?
        
        // TODO: Current version of the settings was used in a auth lesson to display the user information, allow account deletion, and signing out
        
        VStack {
            Text("\(displayName) (\(email))")
                .font(.title)
                .padding()
            
            Section("Account") {
                Button {
                    print("Signing out.")
                } label: {
                    Text("Sign out")
                }
                .padding(10)
                
                Button {
                    print("Deleting account...")
                } label: {
                    Text("Delete account")
                }
            }
        }
        
        
    }
}

#Preview {
    SettingsView()
}
