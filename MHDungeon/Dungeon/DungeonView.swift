//
//  DungeonHostView.swift
//  MHDungeon
//

import SwiftUI

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
                case .decision:
                    // TODO: Create a page for choosing between the unlocked dungeon levels
                    DungeonLandingView()
                        .environment(dungeonState)
            }
        }
    }
}

#Preview {
    DungeonView()
}
