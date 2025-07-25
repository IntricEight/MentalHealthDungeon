//
//  DungeonPageManagement.swift
//  MHDungeon
//

import Foundation

/// Identifies the major pages in the Dungeon system's structure.
public enum DungeonPage {
    /// The hub page of the dungeon system, where the user can see the IP cost of starting a new adventure and
    case landing
    /// The adventuring page where the user confirms the start of an adventure and can check in on its progress when they wish.
    case adventure
    /// The dungeon selection page, where the user is shown a list of accessible and inaccessible `Dungeons` and can choose which to set active.
    case selection
}

// MARK: Set the default values of the dungeon system here
private let DEFAULT_DUNGEON_NAME: String = "Dark Cave"
private let DEFAULT_DUNGEON_VIEW: DungeonPage = .landing

/// Manages the current dungeon page that the user is visiting.
///
/// Used in controlling navigation between the different pages of the Dungeon system.
@Observable
class DungeonState {
    /// The current page location within the dungeon system.
    public private(set) var currentView: DungeonPage
    
    /// The current `Dungeon` selected to view and adventure within.
    public private(set) var currentDungeon: Dungeon?
    
    /// Init which allows the caller to override the default landing page when creating the instance
    ///
    /// - Parameters:
    ///   - page: The enum identifier of the page that the dungeon system should land on when entering the system.
    ///   - dungeonName: The `String` name of the Dungeon that should be loaded when entering the system.
    init(_ page: DungeonPage = DEFAULT_DUNGEON_VIEW, dungeonName: String = DEFAULT_DUNGEON_NAME) {
        // Set the active page of the dungeon system
        self.currentView = page
        
        // Ensure that the default dungeon is created correctly
        do {
            // If a proper name has been passed in, use that. Otherwise, use the default dungeon name
            currentDungeon = try Dungeon(name: dungeonName)
        } catch {
            print("DUNGEON - Failed to create the default dungeon.")
        }
    }
    
    /// Change the current page of the dungeon system.
    ///
    /// - Parameters:
    ///   - to: The  `DungeonPage` element of the desired destination.
    func ChangeView(to page: DungeonPage) {
        self.currentView = page
    }
    
    /// Change the current page of the dungeon system.
    ///
    /// - Parameters:
    ///   - to: The `String` name of the desired destination.
    func ChangeView(to page: String) {
        // Remove spaces and dashes and make the characters lowercase to allow more variety in input
        let characterFilter = CharacterSet(charactersIn: " -")
        let pageName: String = page.components(separatedBy: characterFilter).joined().lowercased()
        
        // Determine the desired destination using the normalized string.
        switch pageName {
            case "landing":
                self.currentView = DungeonPage.landing
            case "adventure":
                self.currentView = DungeonPage.adventure
            case "selection":
                self.currentView = DungeonPage.selection
            default:
                print("No matching view was found. Failed to navigate.")
        }
    }
    
    /// Change the current active `Dungeon` using the name of the new `Dungeon`.
    ///
    /// - Parameters:
    ///   - to: The `String` name of the desired `Dungeon`.
    func ChangeDungeon(to name: String) {
        // Check if the new dungeon is the same as the old one
        if name != currentDungeon?.name {
            // Change the dungeon
            do {
                currentDungeon = try Dungeon(name: name)
            } catch {
                print("No dungeon named \"\(name)\" was found.")
            }
        } else {
            print("Attempted to change the dungeon to the current dungeon.")
        }
    }
}
