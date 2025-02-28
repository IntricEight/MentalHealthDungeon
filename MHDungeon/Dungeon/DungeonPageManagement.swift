//
//  DungeonPageManagement.swift
//  MHDungeon
//

import Foundation

public enum DungeonPage {
    case landing
    case begin
}

@Observable
class DungeonState {
    // MARK: Set the value of the default landing page for the app here
    var currentView: DungeonPage = .landing
    
    // Init while using the default landing page
    init() {}
    
    // Allows the caller to override the default landing page when creating the class if they wish
    init(_ page: DungeonPage) {
        self.currentView = page
    }
}
