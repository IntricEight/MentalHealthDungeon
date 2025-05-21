//
//  DungeonListItem.swift
//  MHDungeon
//

import SwiftUI

struct DungeonListItem: View {
    // Contains the account which stores the user's current progress marker
    @EnvironmentObject var authModel: AuthModel
    
    /// The `Dungeon` being displayed.
    let dungeon: Dungeon?
    
    // Features from the Dungeon that have been brought out into their own variables.
    /// The name of the `Dungeon` level.
    let name: String
    /// The `Inspiration Points` cost of starting the `Dungeon` adventure .
    let cost: Int
    
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
                
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .border(.blue)
                    .frame(width: picWidth, height: picWidth, alignment: .bottom)
                    .overlay {
                        // TODO: Implement the greying out and locked appearance of dungeons that have not been unlocked yet
                        
                        
                    }
            }
            
            VStack {
                Text("\(name)")
                Text("Cost: \(cost)")
                
            }
            
        }
        
    }
}

#Preview {
    let previewDungeon = try! Dungeon(name: "Dark Cave")
    
    DungeonListItem(previewDungeon)
}
