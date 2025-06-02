//
//  DungeonSelectionView.swift
//  MHDungeon
//

import SwiftUI

struct DungeonSelectionView: View {
    @EnvironmentObject var authModel: AuthModel
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    var body: some View {
        // Dungeon button controls
        let buttonRadius: CGFloat = 20
        
        // IDEAFEST - Show the IP that the user currently owns
        let currentPoints: Int = authModel.currentAccount?.inspirationPoints ?? -1
        let maxPoints: Int = authModel.currentAccount?.maxIP ?? -1
        
        VStack {
            RoundedRectangle(cornerRadius: buttonRadius)
                .frame(height: 50)
                .foregroundColor(Color.blue)
                .overlay {
                    Text("Current Points: \(currentPoints) / \(maxPoints)")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.title)
                        .frame(alignment: .center)
                }
                .contentShape(Rectangle())
                .frame(alignment: .top)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            
            
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
                        Text("Cancel")
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
    private var dungeonList: [Dungeon] = (try? Dungeon.GetAllDungeons()) ?? []
    
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
