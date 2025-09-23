//
//  ChangePasswordView.swift
//  MHDungeon
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var authModel: AuthModel
    
    /// The user's new desired password.
    @State var newPassword: String = ""
    
    var body: some View {
        VStack {
            TextField("Password", text: $newPassword)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            
            Button {
                authModel.UpdatePassword(newPassword)
            } label: {
                Text("Update the Password")
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
