//
//  DungeonSelectionView.swift
//  MHDungeon
//

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
            
            // Back button
            Button {
                // Return to the Dungeon landing page
                dungeonState.ChangeView(to: DungeonPage.landing)
                
            } label: {
                RoundedRectangle(cornerRadius: buttonRadius)
                    .frame(height: 50)
                    .foregroundColor(Color.orange)
                    .overlay {
                        Text("Back")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.title)
                            .frame(alignment: .center)
                    }
                    .contentShape(Rectangle())
            }
            .frame(alignment: .bottom)
            .padding(EdgeInsets(top: 0, leading: 64, bottom: 0, trailing: 64))
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
            // Show that no dungeons have been found on their local file.
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
