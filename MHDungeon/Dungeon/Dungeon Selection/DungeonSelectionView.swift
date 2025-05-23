//
//  DungeonSelectionView.swift
//  MHDungeon
//

// TODO: Go around app and make private many of the variables inside Views

import SwiftUI

struct DungeonSelectionView: View {
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    var body: some View {
        // Dungeon button controls
        let buttonRadius: CGFloat = 20
        
        VStack {
            // Display a list of the existing Dungeons
            DungeonListView()
            
            
            Spacer()
            
            
            Button {
                // Return to the Dungeon landing page
                dungeonState.ChangeView(to: DungeonPage.landing)
                
            } label: {
                RoundedRectangle(cornerRadius: buttonRadius)
                    .frame(height: 70)
                    .foregroundColor(Color.orange)
                    .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
            }
            .frame(alignment: .bottom)
        }
    }
}

#Preview {
    DungeonSelectionView()
}

struct DungeonListView: View {
    private var dungeonList: [Dungeon] = (try? Dungeon.getAllDungeons()) ?? []
    
    var body: some View {
        if dungeonList.isEmpty {
            // Show that no tasks exist, and direct them to the task creation button
            // TODO: Style this and include instructions on how to create a task
            Text("No dungeons found on file.")
                .font(.title3)
        } else {
            // List of active tasks
            List(dungeonList) { dungeon in
                DungeonListItem(dungeon)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}
