//
//  DungeonListItem.swift
//  MHDungeon
//

import SwiftUI

struct DungeonListItem: View {
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    /// The `Dungeon` being displayed.
    private let dungeon: Dungeon?
    
    // Features from the Dungeon that have been brought out into their own variables.
    /// The name of the `Dungeon` level.
    private let name: String
    /// The `Inspiration Points` cost of starting the `Dungeon` adventure .
    private let cost: Int
    // TODO: Implement the locking feature that prevents the user from accessing dungeons that they haven't yet unlocked
    /// Whether the displayed `Dungeon` should be locked to the user.
    private let locked: Bool = false
    /// An image that shows what kind of dungeon is being displayed on offer
    private let dungeonImage: String
    
    // Official init, this is what should be used when this view is actually being called by lists.
    /// Initialize the list visual with a `Dungeon` item.
    init(_ dungeon: Dungeon) {
        self.dungeon = dungeon
        
        self.name = dungeon.name
        self.cost = dungeon.cost
        self.dungeonImage = dungeon.imageNames[1]
    }
    
    var body: some View {
        let picWidth = screenWidth * 0.35
        
        // The dungeon's summary image and selection button
        Button {
            print("Dungeon \"\(name)\" has been selected.")

            // Check if the user has permission to access their desired dungeon.
            if !locked {
                // Change the active dungeon
                dungeonState.ChangeDungeon(to: name)
                
                // Return the user to the dungeon landing page with the newly selected dungeon
                dungeonState.ChangeView(to: DungeonPage.landing)
               
            } else {
                print("User attempted to access a locked dungeon")
                
                // TODO: Cause a popup telling the user that they cannot use a locked dungeon? "<name> is locked."
            }
        } label: {
            HStack {
                // TODO: Implement the greying out and locked appearance of dungeons that have not been unlocked yet
                Image(dungeonImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: picWidth, height: picWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.trailing, 15)
                
                VStack(alignment: .leading) {
                    Text("\(name)")
                        .font(.title)
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(Color.black)
                    
                    Text("Cost: \(cost)")
                }
            }
        }
            
            
        
    }
}

#Preview {
    let previewDungeon = try! Dungeon(name: "Dark Cave")
    
    DungeonListItem(previewDungeon)
}
