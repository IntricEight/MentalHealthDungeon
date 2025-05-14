//
//  DungeonPageManagement.swift
//  MHDungeon
//

import Foundation

/// Identifies the pages in the Dungeon system's structure.
public enum DungeonPage {
    case landing
    case adventure
    case selection
}

/// Manages the current dungeon page that the user is visiting.
///
/// Used in controlling navigation between the different pages of the Dungeon system.
@Observable
class DungeonState {
    // MARK: Set the default values of the landing page for the dungeon here
    /// The current page location within the dungeon system.
    var currentView: DungeonPage = .landing
    private let DEFAULT_DUNGEON_NAME = "Dark Cave"
    
    
    
    /// The current `Dungeon` selected to view and adventure within.
    var currentDungeon: Dungeon?
    
    /// Init that uses the default landing page
    init() {
        // MARK: Set the default dungeon here
        do {
            currentDungeon = try Dungeon(name: DEFAULT_DUNGEON_NAME)
        } catch {
            print("DUNGEON - Failed to create the default dungeon.")
        }
    }
    
    /// Init which allows the caller to override the default landing page when creating the instance
    init(_ page: DungeonPage) {
        self.currentView = page
    }
}
