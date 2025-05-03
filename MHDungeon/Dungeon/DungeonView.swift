//
//  DungeonHostView.swift
//  MHDungeon
//

// TODO: Why did I decide to use a management and cases instead of NavStack here? I don't remember, but hopefully I do before I begin working on this in earnest. Otherwise, go back to using NavStack you dolt

import SwiftUI

/// The view page that manages the view display of the application's dungeon interface through the navigation status of `DungeonState`.
struct DungeonView: View {
    @State var dungeonState: DungeonState = DungeonState(.landing)
    
    var body: some View {
        Group {
            // TODO: Develop a hosting view page for the dungeon system. This allows the ContentView navigation to work without interacting with the AppPage enum
            switch dungeonState.currentView {
                case .landing:
                    DungeonLandingView()
                        .environment(dungeonState)
                case .begin:
                    // TODO: Create a page for starting a dungeon once you have enough IP
                    DungeonLandingView()
                        .environment(dungeonState)
            }
        }
    }
}

#Preview {
    DungeonView()
}
