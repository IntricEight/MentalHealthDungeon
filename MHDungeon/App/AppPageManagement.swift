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
}

/// Manages the current major page(s) section of the application.
///
/// Used in controlling navigation between these major sections.
@Observable
class AppState {
    // MARK: Set the value of the default landing page for the app here
    // TODO: Set to Dungeon before the app launch
    /// The current section location within the application.
    var currentView: AppPage = .profile
    
    // Init while using the default landing page
    init() {}
    
    // Allows the caller to override the default landing page when creating the class if they wish
    init(_ page: AppPage) {
        self.currentView = page
    }
}
