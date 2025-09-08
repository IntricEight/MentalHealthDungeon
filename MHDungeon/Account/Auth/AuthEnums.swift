//
//  AuthEnums.swift
//  MHDungeon
//

import Foundation

// Realistically, I'm just going to find some online Regex statement to validate both, so I probably won't end up actually using these. That said, it doesn't hurt to include them for future use

// MARK: Password length requirements
/// The minimum length of a password
let MIN_PASSWORD_LENGTH: Int = 6
/// The maximum length of a password
let MAX_PASSWORD_LENGTH: Int = 32

/// Errors that can occur when adding an email while creating an `Account`.
enum EmailAuthStatus: CustomStringConvertible {
    // The status flagged when a part of the email is missing or improperly written
    /// Nothing is wrong with the email, let the user proceed.
    case None
    /// The email is missing the name before the @ symbol.
    case MissingName
    /// The email's name does not match email format standards.
    case InvalidName
    /// The email is missing the @ symbol.
    case MissingAtSymbol
    /// The email has too many @ symbols to be a real email.
    case TooManyAtSymbols
    /// The email is missing the domain after the @ symbol.
    case MissingDomain
    /// The email's domain does not match domain format standards.
    case InvalidDomain
    
    /// A description of the authentication status that will appear and inform the user of their current issue with their email creation.
    var description: String {
        switch self {
            case .None:
                return ""   // Leave this message empty so that nothing appears in the error section
            case .MissingName:
                return "The email is missing the local name before the '@' symbol (e.g., 'myuser')."
            case .InvalidName:
                return "The email's local name contains invalid characters."
            case .MissingAtSymbol:
                return "The email must contain an '@' symbol."
            case .TooManyAtSymbols:
                return "The email contains more than one '@' symbol."
            case .MissingDomain:
                return "The email is missing a domain (e.g., 'example.com')."
            case .InvalidDomain:
                return "The email's domain is invalid."
        }
    }
}

/// Errors that can occur when adding an email while creating an `Account`.
enum PasswordAuthStatus: CustomStringConvertible {
    // The status flagged when a part of the password is missing or improperly written
    /// Nothing is wrong with the password, let the user proceed.
    case None
    /// The password is either too short or too long.
    case InvalidLength
    /// The password is missing a required capital letter.
    case MissingCapitalLetter
    /// The password is missing a required lowercase letter.
    case MissingLowercaseLetter
    /// The password is missing a required special character.
    case MissingSpecialCharacter
    /// The password has a character that is not allowed.
    case ForbiddenCharacter
    /// The password does not match what the user wrote as the confirmation password. 
    case DifferentConfirmationPassword
    
    /// A description of the authentication status that will appear and inform the user of their current issue with their password creation.
    var description: String {
        switch self {
            case .None:
                return ""   // Leave this message empty so that nothing appears in the error section
            case .InvalidLength:
                return "The password must have between \(MIN_PASSWORD_LENGTH) and \(MAX_PASSWORD_LENGTH) characters."
            case .MissingCapitalLetter:
                return "The password must include at least one uppercase letter."
            case .MissingLowercaseLetter:
                return "The password must include at least one lowercase letter."
            case .MissingSpecialCharacter:
                return "The password must include at least one special character (e.g., !, @, #, $)."
            case .ForbiddenCharacter:
                return "The password cannot include the SPACE or TAB characters."
            case .DifferentConfirmationPassword:
                return "The confirmation password does not match the attempted password."
        }
    }
}
