//
//  PasswordInput.swift
//  MHDungeon
//

import SwiftUI

/// A subview that provides a text field with the option of hiding or revealing the input.
struct PasswordInput: View {
    /// The text to be displayed as a placeholder before the user types anything
    let prompt: String
    /// The value that the user provides.
    @Binding var input: String
    
    /// Controls input visibility for the input field.
    @State private var isSecure: Bool = true
    
    var body: some View {
        // Input field with visibility toggle
        HStack {
            // Show or hide the contents
            Group {
                if isSecure {
                    SecureField(prompt, text: $input)
                        .disableAutocorrection(true)
                } else {
                    TextField(prompt, text: $input)
                        .disableAutocorrection(true)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            
            // Visibility toggle
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(Color.gray)
            }
        }
    }
}
