//
//  DungeonImage.swift
//  MHDungeon
//

import SwiftUI

// TODO: Implement a series of images that show how much IP has been collected through the light on a lamp.
/// A subview which displays an image correlated to the active dungeon and the state of the adventure
struct DungeonImage: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    // Dungeon button controls
    let buttonRadius: CGFloat = 20
    
    @State var stage: Int = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: buttonRadius)
            .foregroundColor(Color.green)
            .frame(height: 400).padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
            .overlay {
                // TODO: Shift the image based on the current stage
                // - Stage 0: Pre-adventure stage, a lamp in the image will slowly light up depending on what percentage of the adventure's required IP is owned by the user.
                // - Stages 1+: Each shows a different image of the dungeon
                //      During IDEAFest version, this should change depending on the percentage of completion the current adventure is at.
                //      TODO: In final version, have this change depending on the Stage of the Dungeon's Level that we are in
                
                
                // TODO: Add the image feature here, and remove the testing text display
                switch stage {
                    case 0:
                    
                        Text("In the starting zone")
                        
                    case 1:
                        
                        Text("Just beginning, are we?")
                        
                    case 2:
                        
                        Text("You're partway there!")
                        
                    case 3:
                        
                        Text("Almost done! You've got this!")
                        
                    default:
                        
                        Text("The default is being displayed?? Uh oh!")
                        
                }
                
                
                
                
            }
    }
}

#Preview {
    DungeonImage()
}
