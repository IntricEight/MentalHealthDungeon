//
//  DungeonPageManagement.swift
//  MHDungeon
//

import Foundation

/// Identifies the pages in the Dungeon system's structure.
public enum DungeonPage {
    case landing
    case begin
}

/// Manages the current dungeon page that the user is visiting.
///
/// Used in controlling navigation between the different pages of the Dungeon system.
@Observable
class DungeonState {
    // MARK: Set the value of the default landing page for the app here
    /// The current page location winth the dungeon system.
    var currentView: DungeonPage = .landing
    
    /// Init that uses the default landing page
    init() {}
    
    /// Init which allows the caller to override the default landing page when creating the instance
    init(_ page: DungeonPage) {
        self.currentView = page
    }
}
