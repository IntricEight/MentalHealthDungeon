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
    
    /// The stage of the dungeon's image that we wish to display.
    ///
    /// Currently, this allows numbers between 0 and 3.
    @State var stage: Int = 0
    
    var body: some View {
        /// The name of the current active `Dungeon`.
        let dungeonName: String = dungeonState.currentDungeon?.name ?? "Dungeon failed to load"
        let dungeonImages: [String] = dungeonState.currentDungeon?.imageNames ?? []
        
        ZStack {
            // The Image Section
            VStack {
                // TODO: Shift the image based on the current stage
                // - Stage 0: Pre-adventure stage, a lamp in the image will slowly light up depending on what percentage of the adventure's required IP is owned by the user.
                // - Stages 1+: Each shows a different image of the dungeon
                //      During IDEAFest version, this should change depending on the percentage of completion the current adventure is at.
                //      TODO: In final version, have this change depending on the Stage of the Dungeon's Level that we are in
                
                if dungeonImages.count != 0 || stage < dungeonImages.count {
                    Image(dungeonImages[stage])
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fill)
                } else {
                    VStack {
                        Text("Image failed to load.")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                
            }.zIndex(1)
            
            //The Label Section
            VStack {
//                Spacer()
                
                // The opaque background of the text
                VStack {
                    // The name of the dungeon
                    Text(dungeonName)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(alignment: .top)
                .frame(maxWidth: .infinity, maxHeight: 80)
                .background(.gray.opacity(0.75))
                
                Spacer()
                
            }.zIndex(10)
        }
        .frame(width: 368, height: 384)
        .background(Color.black)
        .cornerRadius(20)
        .padding([.bottom], 24)
    }
}

#Preview {
    DungeonImage()
}
