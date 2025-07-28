//
//  AppPageManagement.swift
//  MHDungeon
//

import Foundation

// Using an Enum helps error-assistance with page navigation
/// Identifies a major page(s) section in the application structure
public enum AppPage {
    /// The authentication pages, which includes the registration and login views.
    case signIn
    /// The dungeon pages, which includes beginning, finishing, and navigating between dungeons.
    case dungeon
    /// The profile pages, which includes account details, messages, friendships, and character customization.
    case profile
    /// The task management pages, which includes creating and completing tasks.
    case taskList
    /// Left in place for testing purposes, this allows me to navigate to a dedicated Minimal Viable Example page for demonstrations
    case minimal
}

// MARK: Set the default values of the application here
private let DEFAULT_DUNGEON_VIEW: AppPage = .dungeon

/// Manages the current major page(s) section of the application.
///
/// Used in controlling navigation between these major sections.
@Observable
class AppState {
    /// The current section location within the application.
    public private(set) var currentView: AppPage
    
    // Allows the caller to override the default landing page when creating the class if they wish
    init(_ page: AppPage = DEFAULT_DUNGEON_VIEW) {
        self.currentView = page
    }
    
    /// Change the current major page of the application.
    ///
    /// - Parameters:
    ///   - to: The `AppPage` element of the desired destination.
    func ChangeView(to page: AppPage) {
        self.currentView = page
    }
    
    /// Change the current major page of the application.
    ///
    /// - Parameters:
    ///   - to: The `String` name of the desired destination.
    func ChangeView(to page: String) {
        // Remove spaces and dashes and make the characters lowercase to allow more variety in input
        let characterFilter = CharacterSet(charactersIn: " -")
        let pageName: String = page.components(separatedBy: characterFilter).joined().lowercased()
        
        // Determine the desired destination using the normalized string.
        switch pageName {
            case "signin":
                self.currentView = AppPage.signIn
            case "dungeon":
                self.currentView = AppPage.dungeon
            case "profile":
                self.currentView = AppPage.profile
            case "tasklist":
                self.currentView = AppPage.taskList
            case "minimal":
                self.currentView = AppPage.minimal
            default:
                print("No matching view was found. Failed to navigate.")
        }
    }
    
    
}
