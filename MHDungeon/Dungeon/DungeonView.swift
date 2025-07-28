//
//  DungeonHostView.swift
//  MHDungeon
//

import SwiftUI

/// The view page that manages the view display of the application's dungeon interface through the navigation status of `DungeonState`.
struct DungeonView: View {
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    var body: some View {
        Group {
            switch dungeonState.currentView {
                case .landing:
                    DungeonLandingView()
                case .adventure:
                    // The user should only be able to enter this if they have enough IP
                    DungeonAdventureView()
                case .selection:
                    // Choose the currently active dungeon
                    DungeonSelectionView()
            }
        }
    }
}

#Preview {
    DungeonView()
}
