//
//  DungeonListItem.swift
//  MHDungeon
//

import SwiftUI

struct DungeonListItem: View {
    // Contains the account which stores the user's current progress marker
    @EnvironmentObject private var authModel: AuthModel
    
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
    
    // Official init, this is what should be used when this view is actually being called by lists.
    /// Initialize the list visual with a `Dungeon` item.
    init(_ dungeon: Dungeon) {
        self.dungeon = dungeon
        
        self.name = dungeon.name
        self.cost = dungeon.cost
    }
    
    var body: some View {
        let picWidth = screenWidth * 0.35
        
        HStack {
            // The dungeon's summary image and selection button
            Button {
                print("Dungeon \"\(name)\" has been selected.")
                
                // TODO: Change the user's current dungeon to be the new one that the user has selected, unless they are seclecting the currently active one
                
                // Return the user to the dungeon landing page with the newly selected dungeon
            } label: {
                // TODO: Display the topical image of the dungeon. Replace the rounded rectangle with a rounded image?
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: picWidth, height: picWidth, alignment: .bottom)
                    .overlay {
                        // TODO: Implement the greying out and locked appearance of dungeons that have not been unlocked yet
                        
                    }
            }.padding(.trailing, 20)
            
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.title)
                
                Divider()
                
                Text("Cost: \(cost)")
            }
            
        }
        
    }
}

#Preview {
    let previewDungeon = try! Dungeon(name: "Dark Cave")
    
    DungeonListItem(previewDungeon)
}
