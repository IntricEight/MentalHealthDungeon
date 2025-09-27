//
//  RegistrationView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

/// The percentage of the screen that it taken by the border images (Between 0 and 1)
private let IMAGE_BORDER: Double = 0.2

/// A view page that allows the user to register a new account in the application.
///
/// - Note: Intended to be used as a part of a `NavigationStack`
struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authModel: AuthModel
    
    // Gather the user's sign up information
    /// The user's unique email.
    @State private var email: String = ""
    /// The name that the user will be identified by.
    @State private var customName: String = ""
    /// The user's desired password.
    @State private var password: String = ""
    /// A repeat of the user's desired password for verification purposes.
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack {
            Rectangle().fill(Color.blue).frame(height: screenHeight * IMAGE_BORDER)
            
            VStack(spacing: 20) {
                // Title for the create account view
                Text("Lets change your life!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                // Email input field
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                
                // Display name input field
                TextField("Display name (Optional)", text: $customName)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: customName) {
                        if customName.count > MAX_DISPLAY_NAME_LENGTH {
                            customName = String(customName.prefix(MAX_DISPLAY_NAME_LENGTH))
                        }
                    }
                
                // Password input field with visibility toggle
                PasswordInput(prompt: "Password", input: $password)
                    .padding(.horizontal)
                
                // Confirm Password input field with visibility toggle
                PasswordInput(prompt: "Confirm Password", input: $confirmPassword)
                    .padding(.horizontal)
                
                // Error field to inform the user of proper form
                VStack (alignment: .leading, spacing: 20) {
                    Text("\(emailStatus)")
                        .font(.subheadline)
                        .foregroundColor(Color.red)
                    
                    Text("\(passwordStatus)")
                        .font(.subheadline)
                        .foregroundColor(Color.red)
                }
                
                Spacer()
                
                // Navigation buttons
                VStack {
                    // Create Account button
                    Button(action: {
                        print("Create Account tapped with email: '\(email)' and password: '\(password)'")
                        
                        // Logic to process account creation attempt
                        _Concurrency.Task {
                            // Only pass in the email in a lowercase form, to allow the user to write it however they like
                            try await authModel.CreateUser(withEmail: email.lowercased(), displayName: customName, password: password)
                        }
                    }) {
                        Text("Create Account")
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
                    
                    // Move to sign in with an existing account button
                    Button {
                        // Move down the NavigationStack and back to the Sign In page
                        // TODO: If I choose to swap around the order of pages, this and the code in SignInView's action will need to be swapped
                        dismiss()
                    } label: {
                        Text("Sign in with an existing account")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                .frame(alignment: .bottom)
            }
            .padding()
            .frame(height: screenHeight * (1 - IMAGE_BORDER * 2) )
            
            Rectangle().fill(Color.blue).frame(height: screenHeight * IMAGE_BORDER)
        }
        .ignoresSafeArea()
    }
}

// Ensure that valid information is passed into the authentication form
extension RegistrationView: AuthenticationFormProtocol {
    // One issue with the way I have set things up is that only 1 issue with each area will appear at a time
    // I'm going to leave it this way for now, as I want to move on to the visuals of the login and registration pages,
    // but I wanted to note my recognition of this issue and assert that I would not normally leave a task poorly completed.
    
    /// Records any issue found with the user's email.
    var emailStatus: EmailAuthStatus { authModel.AuthenticateEmail(email) }
    
    /// Records any issue found with the user's display name.
    var displayNameStatus: DisplayNameAuthStatus { authModel.AuthenticateDisplayName(customName) }
    
    /// Records any issue found with the user's password.
    var passwordStatus: PasswordAuthStatus { authModel.AuthenticatePassword(password: password, confirmPassword: confirmPassword) }
    
    /// Checks if the user has satisfied the conditions to create their account.
    var formIsValid: Bool {
        // Ensure that there are no issues with the email or password before allowing the user to proceed
        return !email.isEmpty && emailStatus == EmailAuthStatus.None && displayNameStatus == DisplayNameAuthStatus.None && !password.isEmpty && !confirmPassword.isEmpty && passwordStatus == PasswordAuthStatus.None
    }
}

#Preview {
    RegistrationView()
}
