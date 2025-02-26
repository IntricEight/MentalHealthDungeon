//
//  DungeonHostView.swift
//  MHDungeon
//

import SwiftUI

// TODO: Develop a hosting view page for the dungeon system. This allows the ContentView navigation to work without interacting with the AppPage enum

public enum DungeonPage {
    case landing
    case begin
    case decision
}

struct DungeonView: View {
    @State var currentPage: DungeonPage = .landing
    
    var currentView: Binding<AppPage>?      // Passed through here into the NavigationBar
    
    var body: some View {
        Group {
            switch currentPage {
                case .landing:
                    DungeonLandingView(currentView: currentView)
                case .begin:
                    // TODO: Create a page for starting a dungeon once you have enough IP
                    
                    DungeonLandingView(currentView: currentView)
                case .decision:
                    // TODO: Create a page for choosing between the unlocked dungeon levels
                    
                    DungeonLandingView(currentView: currentView)
            }
        }
    }
}

#Preview {
    DungeonView()
}
