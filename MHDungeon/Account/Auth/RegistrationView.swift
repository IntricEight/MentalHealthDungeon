//
//  RegistrationView.swift
//  MHDungeon
//

import SwiftUI
import _Concurrency

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
    
    /// Controls password visibility for the first Password entry field
    @State private var isSecure: Bool = true
    /// Controls password visibility for the Confirm Password entry field
    @State private var isSecureConfirm: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            // Title for the create account view
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Email input field
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .padding(.horizontal)
            
            // Display name input field
            TextField("Display name", text: $customName)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Password input field with visibility toggle
            HStack {
                Group {
                    if isSecure {
                        SecureField("Password", text: $password)
                            .disableAutocorrection(true)
                    } else {
                        TextField("Password", text: $password)
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
            .padding(.horizontal)
            
            // Confirm Password input field with visibility toggle
            HStack {
                Group {
                    if isSecureConfirm {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .disableAutocorrection(true)
                    } else {
                        TextField("Confirm Password", text: $confirmPassword)
                            .disableAutocorrection(true)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                
                // Visibility toggle
                Button {
                    isSecureConfirm.toggle()
                } label: {
                    Image(systemName: isSecureConfirm ? "eye.slash" : "eye")
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.horizontal)
            
            // Error field to inform the user of proper form
            VStack(alignment: .leading, spacing: 20) {
                Text("\(emailStatus)")
                    .font(.subheadline)
                    .foregroundColor(Color.red)
                
                Text("\(passwordStatus)")
                    .font(.subheadline)
                    .foregroundColor(Color.red)
            }
//            .frame(alignment: .leading)
            
            Spacer()
            
            // Navigation buttons
            VStack {
                // Create Account button
                Button(action: {
                    print("Create Account tapped with email: '\(email)' and password: '\(password)'")
                    
                    // Logic to process account creation attempt
                    _Concurrency.Task {
                        try await authModel.CreateUser(withEmail: email, displayName: customName, password: password)
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
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                // Move to sign in with an existing account button
                Button {
                    // Move down the NavigationStack and back to the Sign In page
                    // TODO: If I choose to swap around the order of pages, this and the code in SignInView will need to be swapped
                    dismiss()
                } label: {
                    Text("Sign in with an existing account")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }.frame(alignment: .bottom)
        }
        .padding()
    }
}

// Ensure that valid information is passed into the authentication form
extension RegistrationView: AuthenticationFormProtocol {
    // One issue with the way I have set things up is that only 1 issue with the email will appear at a time
    // I'm going to leave it this way for now, as I want to move on to the visuals of the login and registration pages,
    // but I wanted to note my recognition of this issue and assert that I would not normally leave a task poorly completed.
    
    /// Records any issue found with the user's email.
    var emailStatus: EmailAuthStatus {
        // If the user has not attempted to fill in the email field, then there is no issue at present
        if email.isEmpty {
            return .None
        }
        
        // Separate the email using the @ character
        let parts = email.split(separator: "@", omittingEmptySubsequences: false)
        
        // Check the number of @ symbols using the size of the parts array
        if parts.count < 2 {
            return .MissingAtSymbol
        } else if parts.count > 2 {
            return .TooManyAtSymbols
        }
        
        // Check if either of the sections are empty
        if parts[0].isEmpty {
            return .MissingName
        }
        if parts[1].isEmpty {
            return .MissingDomain
        }
        
        // Ensure that the email name only uses allowed characters
        let localRegex = #"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~.-]+$"#
        let localTest = NSPredicate(format: "SELF MATCHES %@", localRegex)
        if !localTest.evaluate(with: parts[0]) {
            return .InvalidName
        }

        // Ensure that the domain name follows the correct format, and only uses allowed characters
        let domainRegex = #"^(?!.*\.\.)[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#  // #"^[A-Za-z0-9.-]+.[A-Za-z]{2,}$"#
        let domainTest = NSPredicate(format: "SELF MATCHES %@", domainRegex)
        if !domainTest.evaluate(with: parts[1]) {
            return .InvalidDomain
        }
        
        // If we reach this point in the code, there is no issue with the email
        return .None
    }
    
    /// Records any issue found with the user's password.
    var passwordStatus: PasswordAuthStatus {
        // If the user has not attempted to fill in the password field, then there is no issue at present
        if password.isEmpty {
            return .None
        }
        
        // Make sure the password is the proper length
        if password.count < MIN_PASSWORD_LENGTH || password.count > MAX_PASSWORD_LENGTH {
            return .InvalidLength
        }

        // Make sure there is a capital character in the password
        if !password.contains(where: { $0.isUppercase }) {
            return .MissingCapitalLetter
        }
        
        // Make sure there is a lowercase character in the password
        if !password.contains(where: { $0.isLowercase }) {
            return .MissingLowercaseLetter
        }
        
        // Ensure that only allowed special characters are in the password
        // Define the special characters allowed
        let allowedSpecialCharacters = CharacterSet(charactersIn: #"!@#$%^&*()-_=+[]{}|;:'\",.<>?/`~"#)
        if password.rangeOfCharacter(from: allowedSpecialCharacters) == nil {
            return .MissingSpecialCharacter
        }
        
        // Ensure no forbidden characters are in the password
        let allowedCharacters = #"^[A-Za-z0-9!@#$%^&*()_=+\[\]{}|;:'",.<>?\/`~\-]+$"#
        let forbiddenTest = NSPredicate(format: "SELF MATCHES %@", allowedCharacters)
        if !forbiddenTest.evaluate(with: password) {
            return .ForbiddenCharacter
        }

        // Finally, make sure that the confirmation password matches the original password suggestion
        // To avoid early/unnecessary warnings, wait until there is something in the confirmation field before throwing this
        if !confirmPassword.isEmpty && password != confirmPassword {
            return .DifferentConfirmationPassword
        }
        
        // If we reach this point in the code, there is no issue with the password
        return .None
    }
    
    /// Checks if the user has satisfied the conditions to create their account.
    var formIsValid: Bool {
        // Ensure that there are no issues with the email or password before allowing the user to proceed
        return !email.isEmpty && emailStatus == EmailAuthStatus.None && !password.isEmpty && passwordStatus == PasswordAuthStatus.None && !confirmPassword.isEmpty
        
//        return !email.isEmpty && email.contains("@") && !customName.isEmpty && !password.isEmpty && password.count > 5 && password == confirmPassword
    }
}

#Preview {
    RegistrationView()
}
