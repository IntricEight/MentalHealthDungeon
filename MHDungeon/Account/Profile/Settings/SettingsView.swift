//
//  SettingsView.swift
//  MHDungeon
//

import SwiftUI

/// A view page thats allows users to view and change their account details.
struct SettingsView: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // If this page has somehow been navigated to without a user being signed in, display an error
        if let user = authModel.currentAccount {
            VStack {
                HStack {
                    // The user's display name
                    Text(user.displayName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                    
                    Spacer()
                    
                    // Change Display Name button
                    NavigationLink(destination: ChangeNameView()) {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 40))
                            .frame(alignment: .trailing)
                            .padding(.trailing, 8)
                    }
                }
                .padding(.leading, 16)
                .frame(alignment: .top)
                
                Divider()
                    .frame(height: 2)
                    .overlay(Color.black)
                
                Spacer()
                
/* TODO: Account Option ideas:
    * List email (No change option)
    * Change account password
    * Log out
    * Delete account
 */
                List {
                    SettingsListItem(text: "Change Password", icon: "lock") {
                        ChangePasswordView()
                    }
                    
                    // Delete the current account
                    SettingsListItem(text: "Delete Account", icon: "trash") {
                        DeleteAccountView()
                    }
                    
                    // Log out of the current account
                    SettingsListItem(text: "Log Out", icon: "rectangle.portrait.and.arrow.forward") {
                        authModel.SignOut()
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                
                Button {
                    // Return to the central profile page
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 200, height: 40)
                        .foregroundColor(Color.brown)
                        .overlay {
                            Text("Return")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                }
            }.navigationBarBackButtonHidden(true)
        } else {
            // TODO: Create a large error splash page that we can use when a user is not logged in. In fact, make it a separate subview so that it can be thrown up all over the app.
        }
    }
}

#Preview {
    SettingsView()
}
