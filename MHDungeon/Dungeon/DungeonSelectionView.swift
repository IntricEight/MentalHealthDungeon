//
//  DungeonSelectionView.swift
//  MHDungeon
//

// TODO: Go around app and make private many of the variables inside Views

import SwiftUI

struct DungeonSelectionView: View {
    
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
