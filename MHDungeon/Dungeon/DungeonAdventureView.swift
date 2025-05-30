//
//  DungeonAdventureView.swift
//  MHDungeon
//

import SwiftUI

struct DungeonAdventureView: View {
    // Contains the account which stores the timer of the current dungeon
    @EnvironmentObject var authModel: AuthModel
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    
    var body: some View {
        /// The name of the current active `Dungeon`.
        let dungeonName: String = dungeonState.currentDungeon?.name ?? "Dungeon failed to load"
        /// The inspiration point cost of the current `Dungeon`.
        let dungeonCost = dungeonState.currentDungeon?.cost ?? 999
        /// The current number of `Inspiration Points` that the user has in their `Account`.
        let currentPoints = authModel.currentAccount?.inspirationPoints ?? -1
        
        
        // Main screen view
        VStack {
            // Account details section
            HStack {
                // Dungeon selection button
                Button {
                    print("Return to landing selected")
                    
                    // Navigate to the Dungeon Landing page
                    dungeonState.ChangeView(to: .landing)
                } label: {
                    // TODO: Add a back arrow to the button
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 50)
                        .foregroundColor(Color.blue)
                        .contentShape(Rectangle())
                }.padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 32))
                
                Spacer()
                
                // Profile image
                SmallProfileImage()
                    .frame(alignment: .trailing)
            }
            .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
            
            
            // Perhaps add a title line for the level name + stage #?
            
            
            // Dungeon Unlock Progress section
            DungeonImage(stage: 0)
            
            
            // Begin the Adventure section
            Button {
                print("Attempting to begin \(dungeonName) - \(currentPoints)/\(dungeonCost) IP owned.")
                
                // Begin the dungeon's timer
                Dungeon.BeginDungeon(id: dungeonState.currentDungeon?.id ?? 0, authAccess: authModel)
                
                
                
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 70)
                    .foregroundColor(Color.green)
                    .overlay {
                        Text("Begin the Adventure!")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.title)
                            .frame(alignment: .center)
                    }
                    .contentShape(Rectangle())
            }.padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
            
            
            Spacer()
            
            // TODO: Make a list of rewards appear here?
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    DungeonAdventureView()
}
