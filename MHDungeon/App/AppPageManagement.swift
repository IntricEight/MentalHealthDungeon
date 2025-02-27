//
//  AppPageManagement.swift
//  MHDungeon
//

import Foundation

// Using an Enum helps error-assistance with page navigation
public enum AppPage {
    case signIn
    case dungeon
    case profile
    case taskList
}

@Observable
class AppState {
    // MARK: Set the value of the default landing page for the app here
    var currentView: AppPage = .dungeon
    
    // Init while using the default landing page
    init() {}
    
    // Allows the caller to override the default landing page when creating the class if they wish
    init(_ page: AppPage) {
        self.currentView = page
    }
}
